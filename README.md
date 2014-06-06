infinite-scroll [![Build Status](https://travis-ci.org/turn/infinite-scroll.svg?branch=master)](https://travis-ci.org/turn/infinite-scroll)
===============

High performance infinite scrolling for AngularJS.

## Features

- High performance: doesn't slow the user's scrolling
- Tiny
- Configurable
- Unopinionated
- Supports any number of infinite scroll views on one page

## Dependencies

- Angular 1.0.8
- jQuery ^1.11

## Why?

Because [ngInfiniteScroll](https://github.com/BinaryMuse/ngInfiniteScroll) listens to the `onScroll` event, bogging down page performance, and is unnecessarily complex.

## Installation

```bash
bower i -S https://github.com/turn/infinite-scroll.git
```

## Usage

*template.html*

```html
<div infinite-scroll="callbackFn()"></div>
```

*module.js*

```js
require('infinite-scroll');

angular
.module('myModule', ['turn/infiniteScroll'])
...
```

*controller.js*

```js
function Controller ($scope) {
   $scope.callbackFn = function() {
   	  // must return a thenable promise
   	  // see demo/index.html if you're not sure what that means
   };
}
```

*Note: When `callbackFn` returns a rejected promise, infinite-scroll will deactivate itself. It can then be reactivated by setting the infinite-scroll-active attribute to true.*

## Configuration

*template.html*

```html
<!-- basic usage -->
<div infinite-scroll="callbackFn1"></div>

<!-- poll for scrolling every 500ms -->
<div infinite-scroll="callbackFn2" infinite-scroll-interval="500"></div>

<!-- call callbackFn3() when the user is within 200px of the scrollable area's edge -->
<div infinite-scroll="callbackFn3" infinite-scroll-tolerance="200"></div>

<!-- disable infinite scroll when $scope.foo evaluates to false -->
<div infinite-scroll="callbackFn4" infinite-scroll-active="foo == true"></div>

<!-- set infinite scroll className to "inactive" when infinite-scroll is disabled -->
<div infinite-scroll="callbackFn5" infinite-scroll-disabled-class="inactive"></div>
```

## Todo

- Integration tests

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