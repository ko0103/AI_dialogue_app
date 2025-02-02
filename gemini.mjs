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
  res.header("Access-Controll-Allow-Origin", "*");
  res.header("Access-Controll-Allow-Methods", "GET, POST, PUT, DELETE");
  res.header("Access-Controll-Allow-Headers", "Content-Type");
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
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash", systemInstruction: "あなたはユーザーの考えを導く哲学に通じた先生であり、対等な立場の人間でもあります。" });
    const generationConfig = {
      maxOutputTokens: 50,
      temperature: 1.2,
    };
    let systemPrompt = `あなたからの問いかけは最大でも2つまでにしてください。
    またあなたからのテーマとユーザーからのメッセージに対する感想や回答も教えてください。
    以下の哲学対話のルールに従って会話してください。
  - 何を言ってもいい。
  - 人の言うことに対して否定的な態度をとらない。
  - 発言せず、ただ聞いているだけでもいい。
  - お互いに問いかけるようにする。
  - 知識ではなく、自分の経験に即して話す。
  - 話がまとまらなくてもいい。
  - 意見が変わってもいい。
  - 分からなくなってもいい。
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
