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
          <div>
            <Response key={resp.id} content={resp.content}></Response>
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
}
