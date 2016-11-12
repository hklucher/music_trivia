import React from "react"
import ReactDOM from "react-dom"
import {Response} from "./response"

export class ResponsesBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {selected: ''};
  }

  render() {
    if (this.props.responses) {
      const _this = this;
      var responsesList = this.props.responses.map(function(resp) {
        return (
          <div key={resp.id}>
            <Response key={resp.id} content={resp.content} selected={_this.state.selected} id={resp.id} handleChange={_this.handleChange.bind(_this)}></Response>
            <br/>
          </div>
        )
      })
      return (
        <form action="">
          {responsesList}
        </form>

      )
    } else {
      return (<div></div>)
    }
  }

  handleChange(e) {
    console.log(e);
    this.setState({selected: e.target.value});
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
