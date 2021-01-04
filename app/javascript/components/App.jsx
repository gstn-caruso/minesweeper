import * as React from "react";
import {
  useParams,
  Switch,
  Route,
  BrowserRouter as Router, useHistory,
} from "react-router-dom";
import GameGrid from "./GameGrid";

function Child() {
  let {id} = useParams();

  return (
    <div>
      <h3>ID: {id}</h3>
    </div>
  );
}

function CreateAGame() {
  const history = useHistory();

  const newGame = () => {
    return fetch('/api/games', {method: 'POST'})
      .then(response => response.json())
      .then(({game}) => history.push(`/${game.id}`))
  }

  return <button onClick={newGame}>Start new game</button>;
}

const app = () => {
  return <Router>
    <Switch>
      <Route exact path="/" children={<CreateAGame/>}/>
      <Route path="/:id" children={<GameGrid/>}/>
    </Switch>
  </Router>
};

export default app;