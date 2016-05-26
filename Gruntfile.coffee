# Grunt configuration updated to latest Grunt.  That means your minimum
# version necessary to run these tasks is Grunt 0.4.
#
# Please install this locally and install `grunt-cli` globally to run.
module.exports = (grunt) ->
  
  # Initialize the configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    shell:
      start:
        command: "coffee server.coffee"
    clean: 
      tmp: ["tmp"]
      dist: ["dist"]
    copy:
      vendor:
        files: [
          {expand: true, cwd: 'vendor/', src: ['fonts/**/*.*', 'images/**/*.*'], dest: 'dist/'}
        ]
      bootstrap:
        files: [
          {expand: true, cwd: 'node_modules/bootstrap/dist/fonts/', src: ['**'], dest: 'dist/fonts'}
        ]
    concat:
      vendor_js:
        src: [
          "vendor/jquery-ui.min.js"
        ]
        dest: "tmp/vendor.js"
      vendor_css:
        src: [
          "vendor/animate.css"
          "vendor/jquery-ui.min.css"
        ]
        dest: "tmp/vendor.css"
      client_js:
        src: [
          "node_modules/jquery/dist/jquery.js"
          "node_modules/jquery-knob/dist/jquery.knob.min.js"
          "node_modules/bootstrap/dist/js/bootstrap.js"
          "node_modules/react/dist/react.js"
          "node_modules/sweetalert/dist/sweetalert.min.js"
          "tmp/vendor.js"
          "node_modules/blueimp-file-upload/js/jquery.fileupload.js"
          "node_modules/blueimp-file-upload/js/jquery.fileupload-ui.js"
          "node_modules/blueimp-file-upload/js/jquery.iframe-transport.js"
          "tmp/client.js"
        ]
        dest: "dist/client.js"
      admin_js:
        src: [
          "node_modules/jquery/dist/jquery.js"
          "node_modules/jquery-knob/dist/jquery.knob.min.js"
          "node_modules/bootstrap/dist/js/bootstrap.js"
          "node_modules/react/dist/react.js"
          "node_modules/sweetalert/dist/sweetalert.min.js"
          "tmp/vendor.js"
          "node_modules/blueimp-file-upload/js/jquery.fileupload.js"
          "node_modules/blueimp-file-upload/js/jquery.fileupload-ui.js"
          "node_modules/blueimp-file-upload/js/jquery.iframe-transport.js"
          "tmp/admin.js"
        ]
        dest: "dist/admin.js"
      css:
        src: [
          "node_modules/bootstrap/dist/css/bootstrap.css"
          "node_modules/sweetalert/dist/sweetalert.css"
          "node_modules/blueimp-file-upload/css/jquery.fileupload.css"
          "node_modules/blueimp-file-upload/css/jquery.fileupload-ui.css"
          "tmp/vendor.css"
          "tmp/style.css"
        ]
        dest: "dist/style.css"
    stylus:
      app:
        options:
          define:
            import_tree: require 'stylus-import-tree'
            font_face: require 'stylus-font-face'
        files:
          "tmp/style.css": "src/app/stylus/style.styl"
    coffee:
      app:
        options:
          bare: true
        files:
          "tmp/client.js": [ "src/app/coffee/client.coffee", "src/app/coffee/libs/**/*.coffee" ]
          "tmp/admin.js": [ "src/app/coffee/admin.coffee", "src/app/coffee/libs/**/*.coffee" ]
    uglify:
      js:
        files:
          "dist/script.min.js": ["dist/script.js"]
    cssmin:
      target:
        files:
          "dist/style.min.css": ["dist/style.css"]
    watch:
      main:
        files: ["src/app/**/*.*"]
        tasks: ["compile-development"]
    mkdir:
      all:
        options:
          mode: 777
          create: ['dist/files']

  # Load external Grunt task plugins.
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-shell'

  # Default task.
  grunt.registerTask "compile-scripts", ["coffee", "concat:vendor_js", "concat:client_js", "concat:admin_js"]
  grunt.registerTask "compile-styles", ["stylus", "concat:vendor_css", "concat:css"]
  grunt.registerTask "compile-development", ["clean:tmp", "clean:dist", "compile-scripts", "compile-styles", "copy", "mkdir", "clean:tmp"]
  grunt.registerTask "compile-release", ["compile-development", "uglify:js", "cssmin"]

  grunt.registerTask "start-development", ["compile-development", "shell:start", "watch"]  
  grunt.registerTask "start", ["compile-release", "shell:start"]