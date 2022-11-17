---
title: "[Typescript] Vue 元件設計"
date: 2022-11-17T10:51:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[Vue] TS-Component"
    identifier: frontend-vue-ts-component
    parent: frontend
    weight: 1000
---
有時候要重製框架元件，讓元件在 app 內符合統一樣式，把 props, attrs, slot 全部傳給某個 child 的寫法，取例 quasar 的 q-btn：
```html
<template>
  <q-btn outline color="primary" v-bind="$attrs">
    <template
      v-for="(_, slot) in ($slots as Readonly<QBtnSlots>)"
      v-slot:[slot]="scope"
    >
      <slot :name="slot" v-bind="scope"></slot>
    </template>
  </q-btn>
</template>

<script setup lang="ts">
import { QBtnSlots } from 'quasar';
</script>

<style scoped></style>
```