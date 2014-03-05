module.exports = function(config) {

	config.set({
		
		basePath: '',

		frameworks: ['jasmine'],

		// list of files / patterns to load in the browser
		files: [
			// libraries
			'http://code.angularjs.org/1.0.8/angular.js',
			'http://code.angularjs.org/1.0.8/angular-mocks.js',
			'http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js',

			// our app
			'infinite-scroll.js',

			// tests
			'test/test.js'
		],

		autoWatch: true,

		browsers: ['Chrome']

	});

};