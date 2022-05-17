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