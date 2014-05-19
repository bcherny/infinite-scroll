module.exports = (grunt) ->

	[
		'grunt-contrib-clean'
		'grunt-contrib-coffee'
		'grunt-contrib-concat'
		'grunt-contrib-jasmine'
		'grunt-contrib-watch'
		'grunt-html2js'
		'grunt-ngmin'
	].forEach grunt.loadNpmTasks

	# task sets
	build = ['ngmin', 'html2js', 'concat', 'clean']
	test = ['html2js', 'coffee', 'jasmine']

	# task defs
	grunt.initConfig

		pkg: grunt.file.readJSON 'package.json'

		clean:
			main: ['./dist/template.js']

		coffee:
			files:
				'test/test.js': 'test/test.coffee'

		concat:
			main:
				src: ['./dist/template.js', './dist/<%= pkg.name %>.js']
				dest: './dist/<%= pkg.name %>.js'

		html2js:
			main:
				src: './src/*.html'
				dest: './dist/template.js'
			options:
				module: 'infiniteScrollTemplate'

		jasmine:
			test:
				src: './src/<%= pkg.name %>.js'
				options:
					specs: './test/test.js'
					vendor: [
						'./bower_components/jquery/dist/jquery.js'
						'./bower_components/angular/angular.js'
						'./bower_components/angular-mocks/angular-mocks.js'
						'./dist/template.js'
					]
					keepRunner: true

		ngmin:
			main:
				src: ['./src/<%= pkg.name %>.js']
				dest: './dist/<%= pkg.name %>.js'

		watch:
			main:
				files: './src/*'
				tasks: build
				options:
					interrupt: true
					spawn: true
			test:
				files: './test/*.js'
				tasks: test
				options:
					interrupt: true
					spawn: true

	grunt.registerTask 'default', build
	grunt.registerTask 'test', test