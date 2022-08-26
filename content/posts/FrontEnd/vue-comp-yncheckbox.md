---
title: "[DIY] 用 Render Function 打造靈活的 CheckBox 元件範例"
date: 2021-07-29T13:50:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[DIY] CheckBox 元件"
    identifier: frontend-vue-comp-yncheckbox
    parent: frontend
    weight: 1000
---

- 情境1：要選取多個 ckeckbox 對應到資料庫的欄位，欄位值是一串YN代表某個選項是否有被選去，例如： YNNYYNNYYN
- 情境2：要選取多個 ckeckbox 對應到資料庫的欄位，欄位值只有一個，可能是任何字元，例如： 1
可以打造兩個元件，分別對應至單選、多選
# 單選元件
## 程式碼 (Code)

```js
Vue.component('x-ck-single', {
    props: {
    disabled: { type: Boolean, default: () => false },
    // checkbox 的標記 [string] || [{text:string, value:any}]
    labels: { type: Array, default: () => ['Yes', 'No'] }, 
    value: { default: () => null },
    trueValue: { default: () => 'Y' },
    falseValue: { default: () => 'N' },
    inline: { type: Boolean, default: () => false },
  },
  data() {
    return {
      innervalue_: this.value,
    }
  },
  watch: {
    value(v) {
      this.innervalue_ = v
    },
  },
  computed: {
    innervalue: {
      get() {
        return this.innervalue_
      },
      set(v) {
        this.innervalue_ = v
        this.$emit('input', v)
      },
    },
  },
  render: function (h) {
    const self = this

    let len = self.labels.length // labels 的長度
    let allStr = self.labels.every((label) => typeof label == 'string') // 是否為 string
    let allOkObj = self.labels.every((l) => !!l.text && !!l.value) // 是否為合法的物件(如果不是 string)
    let siblingConf = null

    if (allOkObj) {
      siblingConf = self.labels.map((l) => _.pick(l, ['text', 'value']))
    } else if (allStr && len <= 2) {
      siblingConf = self.labels.map((text, idx) => {
        let value = idx === 0 ? self.trueValue : self.falseValue
        return { text, value }
      })
    }

    if (!siblingConf) {
      let errStr = '無法正確設定元件,len,allStr,allOkObj'
      return h('div', errStr, len, allStr, allOkObj)
    }
    // 設定 CheckBox
    let { disabled } = self
    let hideDetails = true
    let dense = true
    const baseProps = { hideDetails, dense, disabled }
    const baseClass = self.inline ? ['d-inline-block'] : []
    let siblings = siblingConf.map((c) => {
      let props = {
        label: c.text,
        inputValue: self.innervalue === c.value,
        ...baseProps,
      }
      // 如果只有一個選項，取消勾選時就顯示 falseValue
      let valueOnNull = len === 1 ? self.falseValue : null
      let on = {
        change: (e) => (self.innervalue = e ? c.value : valueOnNull),
      }
      return h("v-checkbox", { props, class: baseClass, on })
    })
    // 傳回整個元件
    return h('div', {}, siblings)
  }
})
```
<div id="app">
  <x-ck-single v-model="value" inline></x-ck-single>
  {{value === null ? 'null' : value}}
</div>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
<script>
Vue.component('x-ck-single', {
  props: {
  disabled: { type: Boolean, default: () => false },
  // checkbox 的標記 [string] || [{text:string, value:any}]
  labels: { type: Array, default: () => ['Yes', 'No'] }, 
  value: { default: () => null },
  trueValue: { default: () => 'Y' },
  falseValue: { default: () => 'N' },
  inline: { type: Boolean, default: () => false },
  },
  data() {
    return {
      innervalue_: this.value,
    }
  },
  watch: {
    value(v) {
      this.innervalue_ = v
    },
  },
  computed: {
    innervalue: {
      get() {
        return this.innervalue_
      },
      set(v) {
        this.innervalue_ = v
        this.$emit('input', v)
      },
    },
  },
  render: function (h) {
    const self = this
    let len = self.labels.length // labels 的長度
    let allStr = self.labels.every((label) => typeof label == 'string') // 是否為 string
    let allOkObj = self.labels.every((l) => !!l.text && !!l.value) // 是否為合法的物件(如果不是 string)
    let siblingConf = null
    if (allOkObj) {
      siblingConf = self.labels.map((l) => _.pick(l, ['text', 'value']))
    } else if (allStr && len <= 2) {
      siblingConf = self.labels.map((text, idx) => {
        let value = idx === 0 ? self.trueValue : self.falseValue
        return { text, value }
      })
    }
    if (!siblingConf) {
      let errStr = '無法正確設定元件,len,allStr,allOkObj'
      return h('div', errStr, len, allStr, allOkObj)
    }
    // 設定 CheckBox
    let { disabled } = self
    let hideDetails = true
    let dense = true
    const baseProps = { hideDetails, dense, disabled }
    const baseClass = self.inline ? ['d-inline-block'] : []
    let siblings = siblingConf.map((c) => {
      let props = {
        label: c.text,
        inputValue: self.innervalue === c.value,
        ...baseProps,
      }
      // 如果只有一個選項，取消勾選時就顯示 falseValue
      let valueOnNull = len === 1 ? self.falseValue : null
      let on = {
        change: (e) => (self.innervalue = e ? c.value : valueOnNull),
      }
      return h("v-checkbox", { props, class: baseClass, on })
    })
    // 傳回整個元件
    return h('div', {}, siblings)
  }
})
</script>
<script>
  new Vue({
    el: '#app',
    data: { value: '' }
  })
</script>

# 多選元件
## 程式碼 (Code)