import * as React from "react";

export function Cell({row, column, reveal, flag, value}) {
  function classNameFromValue() {
    if (value === '?') {
      return 'hidden'
    }
    if (value === 'F') {
      return 'flagged'
    }
    if (value === 'M') {
      return 'mine'
    }
    if (value === '0') {
      return 'clean'
    }
    if (parseInt(value) > 0) {
      return `number val-${value}`
    }
  }

  function iconsFromValue() {
    if (value === 'M') {
      return <span>💣</span>
    }
    if (value === 'F') {
      return <span>🏁</span>
    } else {
      return <span>{value}</span>
    }
  }

  return (<button className={`cell ${classNameFromValue()}`}
                  onContextMenu={(e) => flag(e, row, column)}
                  onClick={() => reveal(row, column)}>
    {iconsFromValue()}
  </button>)
}