import { install } from 'source-map-support';
install();

import assert from 'assert'
import * as tstore from '../src/tstore'

const mt = tstore.makeTransaction

describe('test_tstore.js', () => {
    it('create transaction', () => {
        let t = mt(':cash', 'food', 100.1, 'RUB')
        assert.equal(t.src, ':cash')
        assert.equal(t.dest, 'food')
        assert.equal(t.amount, 100)
        assert.equal(t.currency, 'RUB')
        assert(t.id)
        assert(t.date)
    })

    it('empty account state', () => {
        let s = new tstore.AccountState()
        assert.deepEqual(s.state, {'0000-00': {}})
    })

    it('add transaction to initial state', () => {
        let s = new tstore.AccountState()

        s.add(mt(':boo', 'foo', 10, 'RUB', '0000-00'))
        assert.deepEqual(s.state, {'0000-00': {':boo': {RUB: -10}}})

        s.add(mt(':boo', 'foo', 20, 'USD', '0000-00'))
        assert.deepEqual(s.state, {'0000-00': {':boo': {RUB: -10, USD: -20}}})

        s.add(mt('bar', ':boo', 5, 'RUB', '0000-00'))
        assert.deepEqual(s.state, {'0000-00': {':boo': {RUB: -5, USD: -20}}})

        s.add(mt(':boo', ':baz', 7, 'RUB', '0000-00'))
        assert.deepEqual(s.state, {'0000-00': {':boo': {RUB: -12, USD: -20},
                                               ':baz': {RUB: 7}}})
        assert.deepEqual(s.diff('0000-00'), {':boo': {RUB: -12, USD: -20},
                                             ':baz': {RUB: 7}})
    })

    it('recalc account balance from past state', () => {
        let s = new tstore.AccountState()

        s.add(mt('foo', ':boo', 10, 'RUB', '2016-01'))
        s.add(mt('foo', ':boo', 20, 'RUB', '2016-02'))
        assert.deepEqual(s.state, {'0000-00': {},
                                   '2016-01': {':boo': {RUB: 10}},
                                   '2016-02': {':boo': {RUB: 30}}})

        s.add(mt(':boo', 'foo', 5, 'RUB', '2016-01'))
        assert.deepEqual(s.state, {'0000-00': {},
                                   '2016-01': {':boo': {RUB: 5}},
                                   '2016-02': {':boo': {RUB: 25}}})

        s.add(mt(':boo', 'foo', 5, 'RUB', '2016-01'))
        assert.deepEqual(s.state, {'0000-00': {},
                                   '2016-01': {},
                                   '2016-02': {':boo': {RUB: 20}}})

        assert.deepEqual(s.diff('2016-01'), {})
        assert.deepEqual(s.diff('2016-02'), {':boo': {RUB: 20}})
    })

    it('balance gaps', () => {
        let s = new tstore.AccountState()
        s.add(mt('foo', ':boo', 10, 'RUB', '0000-00'))
        s.add(mt('foo', ':boo', 20, 'RUB', '2016-02'))
        s.add(mt('foo', ':bar', 10, 'RUB', '2016-01'))
        s.add(mt(':baz', 'foo', 10, 'RUB', '2016-01'))
        assert.deepEqual(s.state, {'0000-00': {':boo': {RUB: 10}},
                                   '2016-01': {':boo': {RUB: 10}, ':bar': {RUB: 10}, ':baz': {RUB: -10}},
                                   '2016-02': {':boo': {RUB: 30}, ':bar': {RUB: 10}, ':baz': {RUB: -10}}})

        assert.deepEqual(s.diff('2016-01'), {':boo': {RUB: 0}, ':bar': {RUB: 10}, ':baz': {RUB: -10}})
        assert.deepEqual(s.diff('2016-02'), {':boo': {RUB: 20}, ':bar': {RUB: 0}, ':baz': {RUB: 0}})
    })
})
