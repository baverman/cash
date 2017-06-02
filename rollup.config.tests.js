import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import babel from 'rollup-plugin-babel';
import multiEntry from 'rollup-plugin-multi-entry';

export default {
    entry: 'tests/**/test_*.js',
    format: 'cjs',
    dest: 'assets/js/tests.js',
    external: ['assert', 'path', 'fs', 'module'],
    plugins: [
        resolve({jsnext: true, main: true, browser: true}),
        commonjs(),
        babel({include: 'src/**'}),
        multiEntry(),
    ],
};
