document.addEventListener("DOMContentLoaded", function() {
  const form = document.querySelector("form");
  const chatLog = document.getElementById("chat-log");
  const messageInput = document.getElementById("message");
  


  if (form) {
    form.addEventListener("submit", function(event) {
      event.preventDefault();

    const message = messageInput.value;
    if (message.trim() === "") {
      alert("メッセージを入力してください");
      return;
    }
    messageInput.value = "";

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content");

    if (!csrfToken) {
      console.error("CSRF token not found.");
      alert("CSRFトークンが見つかりませんでした。");
      return;
    }

    chatLog.innerHTML +=  `<div class="chat-message user-message">${message}</div>`;

    fetch("/chats", {
      method: "POST",
      headers: {
        "Content-Type":"application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ message: message }),
    })
    .then(response => {
      if(!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      data.chat_logs.forEach(log => {
        if (log.role === "user") {
          chatLog.innerHTML += `<div class="chat-message user-message">${log.content}</div>`;
          // chatLog.innerHTML += `<div class="chat-message user-message">${log.content.replace(/<p><strong>user:<\/strong> /, '').replace(/<\/p>/,'')}</div>`
        } else if (log.role === "gemini") {
          chatLog.innerHTML += `<div class="chat-message gemini-message">${log.content}</div>`;
          // chatLog.innerHTML += `<div class="chat-message gemini-message">${log.content.replace(/<p><strong>gemini:<\/strong> /, '').replace(/<\/p>/,'')}</div>`
        }
      });
    })
    .catch(error => {
      console.error("Error:", error);
      alert("エラーが発生しました。")
    });
    });
  }
});
