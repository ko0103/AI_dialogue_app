import dotenv from "dotenv";
dotenv.config();
import express from "express";
import { GoogleGenerativeAI } from "@google/generative-ai";

const app = express();
app.use(express.json());
const port = 3001;

const API_KEY = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(API_KEY)

// アクセス許可
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
  res.header("Access-Control-Allow-Headers", "Content-Type");
  next();
});

// チャットのエンドポイント
app.post("/chat", async (req, res) => {
  try {
    const userInput = req.body.message;
    const theme = req.body.theme;
    const chatHistory = req.body.chatHistory;
    const isLastMessage = req.body.isLastMessage;
    console.log("Received message from Rails:", userInput, theme, chatHistory, isLastMessage); // ログ追加

    if (!userInput) {
      return res.ststus(400).json({ error: "Message is required"});
    }

    // AIの役柄とルール設定
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash", systemInstruction: "あなたは哲学対話のファシリテーターです。ユーザーとの対話を通して、ユーザー自身の考えを深める手助けをしてください。" });
    const generationConfig = {
      maxOutputTokens: 20,
      temperature: 1.2,
    };
    let systemPrompt = `あなたからの問いかけは1つのみにしてください。
    ユーザーから質問されたら返答を返してください。
    意見を述べる際は、自然な文脈となるように絶対に（）の記号を使わないでください。
    メッセージがユーザーにとって読みやすいように改行してください。
    ユーザーから質問された時はその前のメッセージの内容を踏まえて返事をしてください。
    ユーザーが理解しやすいように分かりやすい言葉で短めに対話してください。
    毎回ユーザーからのメッセージに対するあなたからの意見も加えてください。
    特に以下のルールに注意して会話してください。
  - ユーザーの言うことに対して否定的な態度をとらないでください。
  - お互いに問いかけるようにしてください。
  - あなた自身が学習した知識、経験からの意見を出してください。
  - 結論に至らなくても構いません。
  - ユーザーの意見が変わった場合は尊重してください。
  `;
    if (theme) {
      systemPrompt = `現在のテーマは「${theme}」です。\n${systemPrompt}`;
    }
  const chat = model.startChat({
    history: [
      {
        role: "user",
        parts: [{ text: systemPrompt }],
      },
    ],
  });
  const result = await chat.sendMessage(userInput, { generationConfig });
  const response = result.response;
  const geminiResponse = response.text();

  let score = null;
  if (isLastMessage) {
    const evaluationPrompt = `与えられたチャットログが、テーマに沿って論理的な会話ができているか0〜100でスコアで評価してください。\n スコアのみを整数で返してください。`;
    const evaluationResult = await model.generateContent(evaluationPrompt + `
      テーマ: ${theme}
      チャットログ:\n${chatHistory.join("\n")}
    `);
    const evaluationResponse = evaluationResult.response;
    const evaluationText = evaluationResponse.text();
    const extractedScore = evaluationText.match(/(\d+)/);
    score = extractedScore ? parseInt(extractedScore[0], 10) : null;
    console.log("Gemini API evaluation response:", { evaluationResponse, score });
  }
  console.log("Gemini API response:", { gemini: geminiResponse, score: score });
  res.json({ gemini: geminiResponse, score: score });
  } catch (error) {
    console.error("Gemini API error:", error);
    res.status(500).json({ error: "Failed to process Gemini API request" });
   }
});
app.listen(port, () => {
  console.log("Node.js API listening on port ${port}");
});
