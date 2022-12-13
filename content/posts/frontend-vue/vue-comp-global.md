---
title: "[元件] 全域元件"
date: 2022-12-13T15:10:57+08:00
draft: false
hero: 
discription: asdf
menu:
  sidebar:
    name: "[元件] 全域元件"
    identifier: frontend-vue-comp-global
    parent: frontend-vue
    weight: 1000
---
## Vue 的作法
```js
app.component('component-name', component)
```

## Quasar2 的做法
Vite/Typescript

建立 src/boot/register-my-component.ts
```typescript
import { boot } from 'quasar/wrappers';
import BasicBtnVue from 'src/components/BasicBtn.vue';

// "async" is optional;
// more info on params: https://v2.quasar.dev/quasar-cli/boot-files
export default boot(async ({ app }) => {
  app.component('x-btn', BasicBtnVue);
});

```
在 quasar.conf.js 內新增設定
```js
module.exports = configure(function (/* ctx */) {
  return {
    // ...上略
    // https://v2.quasar.dev/quasar-cli-vite/boot-files
    boot: ['i18n', 'register-my-component'],
    // ... 下略
  };
});

```
建立型別定義檔，我放在 src/components 下 
components.d.ts
```ts
import BasicBtn from './BasicBtn.vue';
declare module '@vue/runtime-core' {
  export interface GlobalComponents {
    XBtn: typeof BasicBtn;
  }
}
```