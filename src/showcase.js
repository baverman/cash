import m from 'mithril';
import {KeyPad} from './keypad';
import {TStore, make_transaction} from './tstore';

const state = {
    value: 10
}

const Root = {
    view() {
        return m('.w-100.h-100.overflow-y-hidden.absolute',
            m(KeyPad, {value: state.value, onchange: (it) => state.value = it}),
            m('.pv3', state.value)
        );
    }
}

window.boo = (ref) => {
    console.log(make_transaction(':cash', 'food', 400));
    // let store = new TStore(ref);
    // store.getAccount(':cash');
    // store.getAccount(':alfa:credit');
    // store.getAccount(':alfa:debit');
}

// m.mount(document.body, Root);
