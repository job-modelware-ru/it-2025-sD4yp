import resolve from '@rollup/plugin-node-resolve'
import commonjs from '@rollup/plugin-commonjs'
import { terser } from 'rollup-plugin-terser'
import babel from '@rollup/plugin-babel'
import css from 'rollup-plugin-css-only'

export default {
  input: 'src/main.js',
  output: {
    file: 'dist/bundle.js',
    format: 'esm'
  },
  plugins: [
  resolve(),
  commonjs(),
  css({ output: 'bundle.css' }),
  babel({ babelHelpers: 'bundled' }),
  terser()
  ]
}

