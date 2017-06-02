import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import postcss from 'rollup-plugin-postcss';
import postcssModules from 'postcss-modules';
import uglify from 'rollup-plugin-uglify';
import babel from 'rollup-plugin-babel';

const cssExportMap = {};

export default {
    entry: 'src/app.js',
    format: 'iife',
    dest: 'assets/js/app.js',
    plugins: [
        postcss({extensions: ['.css'],
                 plugins: [
                   postcssModules({
                     getJSON (id, exportTokens) {
                       cssExportMap[id] = exportTokens;
                     }
                   })
                 ],
                 getExport (id) {
                   return cssExportMap[id];
                 }}),
        resolve({jsnext: true, main: true, browser: true}),
        commonjs(),
        babel({include: 'src/**'}),
        (process.env.NODE_ENV === 'production' && uglify()),
    ],
};
