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
            src: ['<%= relativeCoffeePath %>/show.js.coffee', '<%= relativeCoffeePath %>/edit.js.coffee'],
            dest: '<%= widgetPath %>',
            ext: '.js'
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