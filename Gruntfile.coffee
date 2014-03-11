module.exports = (grunt) ->

	nameParts = __dirname.split '/'
	name = nameParts[nameParts.length - 1]
	pkg = grunt.file.readJSON 'package.json'
	deps = grunt.util._.keys pkg.dependencies
	config =

		pkg: pkg

		bytesize:
			all:
				src: []

		coffee:
			compile:
				files: {}
			options:
				bare: true

		uglify:
			options:
				mangle:
					toplevel: true
				compress:
					dead_code: true
					unused: true
					join_vars: true
				comments: false
			standard:
				files: {}

		umd:
			all: {}

		watch:
			all:
				files: [name + '.coffee']
				tasks: ['coffee', 'umd', 'uglify']
				options:
					interrupt: true

	# configure coffee, uglify, umd
	config.bytesize.all.src = [name + '.js', name + '.min.js']
	config.coffee.compile.files[name + '.js'] = name + '.coffee'
	config.uglify.standard.files[name + '.min.js'] = [name + '.js']
	config.umd.all =
		src: name + '.js'
		dest: name + '.js'
		objectToExport: name.replace '-', ''
		amdModuleId: name
		globalAlias: name
		deps:
			default: deps or []

	# load config
	grunt.config.init config

	# load tasks
	grunt.loadNpmTasks 'grunt-bytesize'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-umd'

	# register tasks
	grunt.registerTask 'default', ['coffee', 'umd', 'uglify', 'bytesize']