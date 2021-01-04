import * as React from "react";
import {chunk, indexBy, size} from "underscore";
import {withRouter} from "react-router";

class GameGrid extends React.Component {
  constructor(props) {
    super(props);
    this.state = {game: {}}
  }

  componentDidMount() {
    fetch(`/api/games/${this.props.match.params.id}`)
      .then(response => response.json())
      .then(data => this.setState({...data}))
  }

  cells = () => this.state.game.cells || []

  cellsByRow = () => indexBy(this.cells(), 'row');
  cellsByColumn = () => indexBy(this.cells(), 'column');

  rowAmount = () => {
    return size(this.cellsByRow())
  }

  columnAmount = () => {
    return size(this.cellsByColumn())
  }

  reveal = (row, column) => {
    fetch(`/api/games/${this.props.match.params.id}/reveal`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({row: row, column: column})
    })
      .then(response => response.json())
      .then(data => this.setState({...data}))
  }

  cellRows = () => {
    return <ul>
      {chunk(this.cells(), this.rowAmount()).map((row) => {
        return <li key={row[0].row}>
          {row.map(({row, column, value}) => {
            return <button key={row + column} onClick={() => this.reveal(row, column)}>{value}</button>;
          })}
        </li>
      })}

    </ul>
  }

  render() {
    return <>
      <p>Rows: {this.rowAmount()}</p>
      <p>Columns: {this.columnAmount()}</p>
      {this.cellRows()}
    </>
  }
}

export default withRouter(GameGrid)