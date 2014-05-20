angular.module('infiniteScrollTemplate', ['infinite-scroll.html']);

angular.module("infinite-scroll.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("infinite-scroll.html",
    "<div ng-transclude></div>");
}]);

// Generated by CoffeeScript 1.7.1
angular.module('turn/infiniteScroll', ['infiniteScrollTemplate']).constant('infiniteScrollDefaults', {
  interval: 100,
  tolerance: 0
}).directive('infiniteScroll', [
  '$window',
  'infiniteScrollDefaults',
  function ($window, infiniteScrollDefaults) {
    return {
      replace: true,
      restrict: 'A',
      templateUrl: 'infinite-scroll.html',
      transclude: true,
      scope: {
        fn: '&infiniteScroll',
        interval: '&infiniteScrollInterval',
        tolerance: '&infiniteScrollTolerance',
        active: '=infiniteScrollActive'
      },
      link: function (scope, element, attrs) {
        if (!angular.isFunction(scope.fn)) {
          throw new TypeError('infinite-scroll expects scroll function to be defined on scope');
        }
        if (!angular.isNumber(scope.interval)) {
          scope.interval = infiniteScrollDefaults.interval;
        }
        if (!angular.isNumber(scope.tolerance)) {
          scope.tolerance = infiniteScrollDefaults.tolerance;
        }
        angular.extend(scope, {
          timer: null,
          isLoading: false,
          windowHeight: 0,
          elementOffset: element.offset(),
          check: function () {
            if (scope.isLoading) {
              return false;
            }
            if ($window.pageYOffset + scope.windowHeight + scope.tolerance - element[0].scrollHeight - scope.elementOffset.top > 0) {
              return scope.load();
            }
          },
          load: function () {
            scope.isLoading = true;
            return scope.fn().then(scope.done, scope.done);
          },
          done: function () {
            return scope.isLoading = false;
          },
          measure: function () {
            return scope.windowHeight = $window.innerHeight;
          },
          setActive: function (active) {
            clearInterval(scope.timer);
            if (active) {
              return scope.timer = setInterval(scope.check, scope.interval);
            }
          }
        });
        scope.measure();
        if (angular.isDefined(scope.active)) {
          scope.$watch('active', scope.setActive);
        } else {
          scope.setActive(true);
        }
        $window.addEventListener('resize', scope.measure);
        return scope.$on('$destroy', function () {
          clearInterval(scope.timer);
          return $window.removeEventListener('resize', scope.measure);
        });
      }
    };
  }
]);