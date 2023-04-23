---
title: "[元件] 把 attr、event、slot，直接 Passthrough 給子元件，製作包裝元件"
date: 2023-04-06T14:21:00+08:00
draft: false
hero: 
discription: overrite component
menu:
  sidebar:
    name: "[元件] Transparent Wrapper"
    identifier: frontend-vue-comp-wrapper
    parent: frontend-vue
    weight: 1000
---
用來複寫給專案用的元件，用於在既有 UI framework 上打造專案元件
## Vue3
### Vue2.6
```html
<template>
  <q-btn v-bind="{ ...$attrs, ...$props }" v-on="$listeners">
    <template v-for="(_, slot) of $scopedSlots" v-slot:[slot]="scope">
      <slot :name="slot" v-bind="scope"/>
    </template>
    <slot></slot>
  </q-btn>
</template>
```
### Vue3
Vue3 裡面只要綁定 $attrs 即可，attrs, props, event 全部自動綁定進去。
```html
<template>
  <q-btn v-bind="$attrs">
    <template v-for="(slot, index) of Object.keys($slots)" :key="index" v-slot:[slot]>
      <slot :name="slot"></slot>
    </template>
    <slot></slot>
  </q-btn>
</template>
```
### Quasar2-TS
Quasar 裡面 Props, Slot 有獨立的 interface 定義，因此可直接拿到。
```html
<template>
  <q-btn v-bind="$attrs">
    <template v-for="(slot, index) of Object.keys($slots)" :key="index" v-slot:[slot]>
      <slot :name="slot"></slot>
    </template>
  </q-btn>
</template>

<script setup lang="ts">
import type { QBtnSlots, QBtnProps } from 'quasar';
import { QBtn } from 'quasar';
const props = withDefaults(defineProps<QBtnProps>(),{
  // here comes default settings
});
</script>

<style scoped></style>
```
### Vuetify3
Vuetify3 裡面 Props, Slot 沒有獨立的 interface 定義，因此需額外定義。
`MyBtn.vue`
```html
<template>
  <div>
    <v-btn v-bind="$attrs">
      <template v-for="(slot, index) of Object.keys($slots)" :key="index" v-slot:[slot]>
        <slot :name="slot"></slot>
      </template>
    </v-btn>
  </div>
</template>

<script setup></script>
```
`MyBtn.vue.d.ts`，這裡要注意`"vuetify/components"`而不是`"vuetify/lib/components"`，
```ts
import { VBtn } from "vuetify/components";
export default VBtn
```

## Reference
- [Vue.js - TypeScript with Composition API](https://vuejs.org/guide/typescript/composition-api.html#typing-component-props)