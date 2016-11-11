import React from "react"
import ReactDOM from "react-dom"
import {Response} from "./response"

export class ResponsesBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    if (this.props.responses) {
      var responsesList = this.props.responses.map(function(resp) {
        return (
          <div key={resp.id}>
            <Response key={resp.id} content={resp.content} id={resp.id}></Response>
            <br/>
          </div>
        )
      })
      return (
        <form action="">
          {this._shuffleResponseOrder(responsesList)}
        </form>
      )
    } else {
      return (<div></div>)
    }
  }

  _shuffleResponseOrder(array) {
    var currentIndex = array.length, temporaryValue, randomIndex;

    while (0 !== currentIndex) {
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;

      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }

    return array;
  }
}
