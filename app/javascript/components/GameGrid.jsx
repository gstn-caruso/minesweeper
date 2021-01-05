import * as React from "react";
import {chunk, indexBy, size} from "underscore";
import {withRouter} from "react-router";
import SecondsSince from "./SecondsSince";
import {Cell} from "./Cell";

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

  flag = (event, row, column) => {
    event.preventDefault();
    fetch(`/api/games/${this.props.match.params.id}/flag`, {
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
            return <Cell key={row + column}
                         value={value}
                         row={row}
                         column={column}
                         flag={this.flag}
                         reveal={this.reveal}/>;
          })}
        </li>
      })}

    </ul>
  }

  timer = () => {
    if (this.state.game['started_at']) {
      return <SecondsSince dateTime={this.state.game['started_at']}/>;
    } else {
      return <p>0</p>;
    }
  };

  render() {
    return <>
      {this.timer()}
      <p>Rows: {this.rowAmount()}</p>
      <p>Columns: {this.columnAmount()}</p>
      {this.cellRows()}
    </>
  }
}

export default withRouter(GameGrid)
