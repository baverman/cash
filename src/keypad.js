import m from 'mithril';
import csjs from 'csjs-inject';
import {styled} from './utils';

const styles = csjs`
    .keypad {
        width: 100%;
    }
    .keypad td {
        width: 25%;
        text-align: center;
        padding: 0.5rem 0 0.5rem 0;
        font-size: 2rem;
        color: #333;
        border: 2px solid white;
        color: #eee;
    }
    .num {
        background: #555;
    }
`;

const h = styled(m, styles);
const eval2 = eval;

class Calculator {
    constructor(value) {
        this.value = value;
        this.expr = this.value.toString();
        this.isEnd = false;
    }

    feed(symbol) {
        if (symbol === 'C') {
            this.expr = '0'
        } else if (symbol === 'B') {
            if (this.expr.length > 1) {
                this.expr = this.expr.slice(0, -1);
            } else {
                this.expr = '0';
            }
        } else if (symbol === '=') {
            let result = eval2(this.expr).toString();
            this.isEnd = result === this.expr;
            this.expr = result;
        } else {
            if (this.expr === '0') {
                this.expr = '';
            }
            this.expr += symbol.toString();
        }
        return this.expr;
    }
}

export const KeyPad = {
    oninit(vnode) {
        this.calc = new Calculator(vnode.attrs.value || 0);
    },
    handle(symbol) {
        this.attrs.onchange(this.state.calc.feed(symbol), this.state.calc.isEnd);
    },
    view(vnode) {
        return h('table.keypad',
            h('tr',
                h('td.bg-orange', {onclick: this.handle.bind(vnode, 'C')}, 'C'),
                h('td.bg-blue', {onclick: this.handle.bind(vnode, '/')}, m.trust('&divide;')),
                h('td.bg-blue', {onclick: this.handle.bind(vnode, '*')}, m.trust('&times;')),
                h('td.bg-gold', {onclick: this.handle.bind(vnode, 'B')}, m.trust('&larr;')),
            ),
            h('tr',
                h('td.num', {onclick: this.handle.bind(vnode, 7)}, '7'),
                h('td.num', {onclick: this.handle.bind(vnode, 8)}, '8'),
                h('td.num', {onclick: this.handle.bind(vnode, 9)}, '9'),
                h('td.bg-blue', {onclick: this.handle.bind(vnode, '-')}, m.trust('&minus;')),
            ),
            h('tr',
                h('td.num', {onclick: this.handle.bind(vnode, 4)}, '4'),
                h('td.num', {onclick: this.handle.bind(vnode, 5)}, '5'),
                h('td.num', {onclick: this.handle.bind(vnode, 6)}, '6'),
                h('td.bg-blue', {onclick: this.handle.bind(vnode, '+')}, m.trust('&plus;')),
            ),
            h('tr',
                h('td.num', {onclick: this.handle.bind(vnode, 1)}, '1'),
                h('td.num', {onclick: this.handle.bind(vnode, 2)}, '2'),
                h('td.num', {onclick: this.handle.bind(vnode, 3)}, '3'),
                h('td.bg-green', {rowspan: 2, onclick: this.handle.bind(vnode, '=')}, '='),
            ),
            h('tr',
                h('td.bg-gray', {colspan: 2, onclick: this.handle.bind(vnode, 0)}, '0'),
                h('td.bg-gray', {onclick: this.handle.bind(vnode, '.')}, '.'),
            )
        );
    }
}
