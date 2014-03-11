(function(root, factory) {
    if(typeof exports === 'object') {
        module.exports = factory();
    }
    else if(typeof define === 'function' && define.amd) {
        define('infinite-scroll', [], factory);
    }
    else {
        root['infinite-scroll'] = factory();
    }
}(this, function() {

/*
	
	infinite-scroll
	
	@dependencies angularjs
	@author Boris Cherny <bcherny@turn.com>
	@license Apache2 <http://www.apache.org/licenses/LICENSE-2.0.txt>
	@usage <div infinite-scroll="callbackFn"></div>
 */
return [
  '$window', function($window) {
    var infinitescroll, options;
    options = {
      interval: 100,
      tolerance: 100
    };
    return infinitescroll = {
      restrict: 'A',
      scope: false,
      link: function($scope, element, attrs) {
        var check, fn, getVisibility, interval, isLoading, measureWindowHeight, visibilityChange, windowHeight;
        fn = attrs.infiniteScroll;
        interval = null;
        isLoading = false;
        windowHeight = 0;
        check = function() {
          if (isLoading) {
            return;
          }
          if ($window.pageYOffset + windowHeight - options.tolerance - element.height() > 0) {
            isLoading = true;
            ($scope[fn]()).then(function() {
              return isLoading = false;
            });
            return $scope.$apply();
          }
        };
        measureWindowHeight = function() {
          return windowHeight = $window.innerHeight;
        };
        visibilityChange = function(visible) {
          clearInterval(interval);
          if (visible) {
            return interval = setInterval(check, options.interval);
          }
        };
        getVisibility = function() {
          return !!element[0].offsetHeight;
        };
        if (!$scope[fn]) {
          throw new TypeError("infinite-scroll expects function '" + fn + "' to be defined on $scope");
        }
        if (attrs.infiniteScrollInterval > -1) {
          options.interval = attrs.infiniteScrollInterval;
        }
        if (attrs.infiniteScrollTolerance > -1) {
          options.tolerance = attrs.infiniteScrollTolerance;
        }
        measureWindowHeight();
        $scope.$watch(getVisibility, visibilityChange);
        $window.addEventListener('resize', measureWindowHeight);
        return $scope.$on('$destroy', function() {
          clearInterval(interval);
          return $window.removeEventListener('resize', measureWindowHeight);
        });
      }
    };
  }
];

    return infinitescroll;
}));
