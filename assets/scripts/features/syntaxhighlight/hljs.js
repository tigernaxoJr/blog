import hljs from 'highlight.js'
import CopyButtonPlugin from './highlightjs-copy.min.js'
import * as params from '@params'

const defaultOptions = {
  ignoreUnescapedHTML: true
}

hljs.configure({
    ...defaultOptions,
    ...(params.syntaxhighlight?.hljs || {}),
});
hljs.addPlugin(new CopyButtonPlugin());
hljs.highlightAll();