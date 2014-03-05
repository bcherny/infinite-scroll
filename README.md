infinite-scroll
===============

High performance infinite scrolling for AngularJS.

## Features

- High performance: doesn't slow the user's scrolling
- Tiny
- Configurable
- Supports any number of infinite scroll views on one page

## Why?

Because [ngInfiniteScroll](https://github.com/BinaryMuse/ngInfiniteScroll) listens to the `onScroll` event, bogging down page performance, and is unnecessarily complex.

## Installation

```bash
npm install --save git://stash.turn.com:7999/cnsl/infinite-scroll.git
```

## Usage

*template.html*

```html
<div ng-infinite-scroll="callbackFn"></div>
```

*module.js*

```js
var infiniteScroll = require('infinite-scroll');

angular
.module('myModule', [])
.directive('infiniteScroll', infiniteScroll);
```

*controller.js*

```js
function Controller ($scope) {
   $scope.callbackFn = function() { ... };
}
```

## Configuration

*template.html*

```html
<!-- basic usage -->
<div ng-infinite-scroll="callbackFn1"></div>

<!-- poll for scrolling every 500ms -->
<div ng-infinite-scroll="callbackFn2" ng-infinite-scroll-interval="500"></div>

<!-- call callbackFn3() when the user is within 200px of the scrollable area's edge -->
<div ng-infinite-scroll="callbackFn3" ng-infinite-scroll-tollerance="200"></div>
```

## License

```
Copyright 2014 Turn Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```