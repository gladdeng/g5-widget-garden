module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        files: {
          'public/static/components/**/javascripts/show.js': ['public/static/components/**/javascripts/show/*.js.coffee'],
          'public/static/components/**/javascripts/edit.js': ['public/static/components/**/javascripts/edit/*.js.coffee']
        }
      }
    },
    watch: {
      files: ['public/static/components/**/javascripts/**/*.js.coffee'],
      tasks: ['coffee']
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  grunt.registerTask('default', ['coffee']);
};