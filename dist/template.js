angular.module('infiniteScrollTemplate', ['infinite-scroll.html']);

angular.module("infinite-scroll.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("infinite-scroll.html",
    "<div ng-transclude></div>");
}]);
