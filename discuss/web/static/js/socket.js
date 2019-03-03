import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  // pass the comment Id to the join function of the comments channel
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => { 
        // this is where you get the comments/data the server is streaming
        renderComments(resp.comments)
     })
    .receive("error", resp => { console.log("Unable to join", resp) })

    document.querySelector('button').addEventListener('click', () => {
      const content = document.querySelector('textarea').value

      // call the handle_in function on the phx side (in comments channel)
      channel.push('comment:add', {content: content})
    })
}
const renderComments = (comments) => {
  const renderedComments = comments.map((comment, index) => {
    return `
      <li class="collection-item">
        ${comment.content}
      </li>
    `
  })
  document.querySelector('.collection').innerHTML = renderedComments.join('')
}



window.createSocket = createSocket
