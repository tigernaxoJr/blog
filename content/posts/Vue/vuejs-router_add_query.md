---
title: "[DIY] Vue Router 使用 Navigation Guard 加入查詢參數"
date: 2021-08-19T17:20:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[DIY] Navigation Guard 加入查詢參數"
    identifier: vuejs-router-naviguard-param
    parent: vue
    weight: 1000
---
工作上需要把每一個路由都加上同一個 query string
第一直覺就是直接寫成這樣： 
```js
router.beforeEach(async (to, from, next) => {
  next({
    path: path, 
    query: {...to.queryl ,token: tokenStr}
  })
})
```
結果卻跳出 `Maximum call stack size exceeded` 的錯誤，判斷程式出現無窮迴圈：
```
runtime.js?96cf:285 Uncaught (in promise) RangeError: Maximum call stack size exceeded
```
第一個反應是傻眼貓咪，為什麼 `next()` 不傳入參數的時候不會出現無窮迴圈，但塞進參數就會，
難道說 `next()` 在傳入參數與不傳入參數的行為並不相同！！
因此去翻閱官網對 `next()` 的說明：
> next: Function: **this function must be called to resolve the hook.** The action depends on the arguments provided to next:
>
> **next(): move on to the next hook in the pipeline.** If no hooks are left, the navigation is confirmed.
>
> ... 中略
> 
> **next('/') or next({ path: '/' })**: **redirect** to a different location. **The current navigation will be aborted and a new one will be started.** You can pass any location object to next, which allows you to specify options like replace: true, name: 'home' and any option used in router-link's to prop or router.push
>
> ...下略


 - `next()` 不帶參數：會直接解開(resolve) Hook 使 navigation 往下繼續，
因此總共只會進入 Navigation Guard 1次；
 - `next('/')` 或 `next({...})`，會放棄該次 navigation 進行重新導向(redirect)，
而不是用參數繼續同一個 navigation，因此會再次進入 Navigation Guard。

**=>重要：`next('/')` 或 `next({...})` 不會解開 beforeEach hook！！
重新導向後不帶參數的 next() 才繼續解開下一次的 beforeEach**，
因此如果再次進入 Navigation Guard 後又呼叫同一個帶設定參數的 `next({...})` 就會造成無窮迴圈了。

解決方法：
在給予參數的時候寫入判斷，如果參數沒有就加上參數重新 navigation；
如果有參數就呼叫 `next()` 解開 hook 完成該次 navigation，
因為加上參數重新導向後就可以呼叫 `next()`，所以不會出現無窮迴圈：

# 程式碼：
```js
router.beforeEach(async (to, from, next) => {
  if (!to.query.key) {
    next({ path: to.path, query: { key: store.state.token } })
  } else {
    next()
  }
})
```
# Reference
[Vue-Router navigation-guards](https://router.vuejs.org/guide/advanced/navigation-guards.html#global-before-guards)