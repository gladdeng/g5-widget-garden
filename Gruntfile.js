module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    widgetPath: 'public/static/components',
    relativeCoffeePath: '**/javascripts/**',
    coffee: {
      compile: {
        files: [
          {
            expand: true,
            cwd: '<%= widgetPath %>',
            src: '<%= relativeCoffeePath %>/*.js.coffee',
            dest: '<%= widgetPath %>/',
            ext: '.js',
            rename: function(dest, src){
              // Split the src into an array of path components
              srcComponents = src.split("/")
              // Cut out the second to last one
              srcComponents.splice(srcComponents.length - 2, 1)
              // Join the path components back together into a path
              newSrc = srcComponents.join("/")

              return dest + newSrc
            }
          }
        ]
      }
    },
    watch: {
      files: ['<%= widgetPath %>/<%= relativeCoffeePath %>/*.js.coffee'],
      tasks: ['coffee']
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  grunt.registerTask('default', ['coffee']);
};