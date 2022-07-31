## 0.0.1

* Initial release

## 0.0.1+1

* Remove duplicated code

## 0.1.0

* Implement AppObserver API to allow elements handle memory pressure and app lifecycle change
* Change code organization
* Support creating custom variations of `FlateService`, `FlatePart`, `FlateFragment`
* Implement `FlateComponentMixin` used to create logical ui components
* Remove `onNotification` method from FlateComponentModel
* Implement `ReduceRebuild` mixin and `StatelessReduceRebuildWidget` for widget rebuild optimization 
* Optimize internal implementation

## 0.1.1
* Remove AppObserver API. It's now part of user implementation
* Implement FlateConfiguration for configuration purpose
* Refactor elements Registration API. Now user can provide custom 
  FlateRegistry implementation via FlateConfiguration
* add missing fields to Flate widget

## 0.2.0
* Reimplement Component API
* Remove primitive FlatePart

## 0.2.1
* [FIX] resolve problem with assertion when try to provide Fragment using method `useElement`