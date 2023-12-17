'use strict';

import { readFileSync } from 'node:fs';

// const txt = readFileSync('test.txt', { encoding: 'utf8' });
const txt = readFileSync('input.txt', { encoding: 'utf8' });

class Box {
  /** @type {String[]} */
  order = [];
  /** @type {{[x: String]: number}} */
  kv = {};

  /**
   * @param {string} id
   * @param {number} v
   * @returns {void}
   */
  add(id, v) {
    if (!Object.hasOwn(this.kv, id)) this.order.push(id);
    this.kv[id] = v;
  }

  /**
   * @param {String} id
   * @returns {void}
   */
  rm(id) {
    if (!Object.hasOwn(this.kv, id)) return;
    delete this.kv[id];
    const idx = this.order.findIndex((v) => v === id);
    this.order.splice(idx, 1);
  }
}

const map = new Array(256).fill(0).map((_) => new Box());

/**
 * @param {String} str
 * @returns {number}
 */
function hash(str) {
  let acc = 0;
  for (let i = 0; i < str.length; i++) {
    acc += str.charCodeAt(i);
    acc *= 17;
    acc %= 256;
  }
  return acc;
}

const chunks = txt.trim().split(',');

for (const chunk of chunks) {
  //@ts-expect-error
  const [_, id, op] = chunk.match(/(\w+)=?(\d|-)/);

  const box_ptr = map[hash(id)];
  if (op === '-') box_ptr.rm(id);
  else box_ptr.add(id, Number.parseInt(op));
}

let acc = 0;
for (let i = 0; i < map.length; i++) {
  const b = map[i];
  for (let j = 0; j < b.order.length; j++) {
    const k = b.order[j];
    acc += (i + 1) * (j + 1) * b.kv[k];
  }
}

console.log(acc);
