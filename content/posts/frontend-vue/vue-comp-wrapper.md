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
    <template v-for="(_, slot) of $slots" v-slot:[slot]="scope">
      <slot :name="slot" v-bind="scope"></slot>
    </template>
    <slot></slot>
  </q-btn>
</template>
```
## TS-SFC
### Quasar2
Quasar 裡面 Props, Slot 有獨立的 interface 定義，因此可直接拿到。
```html
<template>
  <q-btn v-bind="$attrs">
    <template v-for="(_, slot) in slots" :key="slot" v-slot:[slot]="scope" >
      <slot :name="slot" v-bind="scope" :key="slot" />
    </template>
    <slot></slot>
  </q-btn>
</template>

<script setup lang="ts">
import type { QBtnSlots, QBtnProps } from 'quasar';
import { QBtn } from 'quasar';
import { useSlots } from 'vue';
const props = withDefaults(defineProps<QBtnProps>(),{
  // here comes default settings
});
const slots = useSlot() as never as QBtnSlots;
</script>

<style scoped></style>
```
### Vuetify3
Vuetify3 裡面 Props, Slot 沒有獨立的 interface 定義，因此需傳入物件來描述 Prop, Slot。(An object literal type)
```html
<template>
  <v-btn v-bind="$attrs">
    <template v-for="(_, slot) in slots" :key="slot" v-slot:[slot]="scope" >
      <slot :name="slot" v-bind="scope" :key="slot" />
    </template>
    <slot></slot>
  </v-btn>
</template>

<script setup lang="ts">
import { VBtn } from 'vuetify/components';
import { useSlots} from 'vue';
var c = new VBtn()
type Props = typeof c.$props
type Slots = typeof c.$slots
const props = withDefaults(defineProps<Props>(), {
  // here comes default settings
});
const slots = useSlots() as never as Slots;
```

## Reference
- [Vue.js - TypeScript with Composition API](https://vuejs.org/guide/typescript/composition-api.html#typing-component-props)