---
title: "[元件] 把 attr、event、slot，直接 Passthrough 給子元件，製作包裝元件"
date: 2022-12-02T09:01:00+08:00
draft: false
hero: 
discription: overrite component
menu:
  sidebar:
    name: "[元件] Wrapper Component"
    identifier: frontend-vue-comp-wrapper
    parent: frontend-vue
    weight: 1000
---
用來複寫給專案用的元件，用於在既有 UI framework 上打造專案元件
## Vue3
### Vue3
```html
<template>
  <q-btn v-bind="$attrs">
    <template v-for="(_, slot) of $slots" v-slot:[slot]="scope">
      <slot :name="slot" v-bind="scope"></slot>
    </template>
    <slot></slot>
  </q-btn>
</template>
```
### TS
要注意不能使用直接從其他檔案 import 的 type/interface，[官方文件](https://vuejs.org/api/sfc-script-setup.html#typescript-only-features)中提到：
> Currently complex types and type imports from other files are not supported. It is possible to support type imports in the future.
Workaround: 在本地擋案 extends 原本的 interface
```html
<template>
  <q-btn v-bind="$attrs">
    <template
      v-for="(_, slot) in ($slots as Readonly<QBtnSlots>)"
      v-slot:[slot]="scope"
    >
      <slot :name="slot" v-bind="scope"></slot>
    </template>
    <slot></slot>
  </q-btn>
</template>

<script setup lang="ts">
import type { QBtnSlots, QBtnProps } from 'quasar';
import { QBtn } from 'quasar';
// 這樣 Wrapper SFC 才會獲得 IDE 支援 
interface IProps extends QBtnProps {
  mock?: undefined;
}
defineProps<IProps>();
</script>

<style scoped></style>
```
## Vue2.6
```html
<template>
  <q-btn v-bind="$attrs" v-on="$listeners">
    <template v-for="(_, slot) of $scopedSlots" v-slot:[slot]="scope">
      <slot :name="slot" v-bind="scope"/>
    </template>
    <slot></slot>
  </q-btn>
</template>
```
