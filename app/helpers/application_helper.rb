module ApplicationHelper
  def default_meta_tags
    {
      site: "AI_dialogue",
      title: "AI_dialogue",
      reverse: true,
      charset: "utf-8",
      description: "AIとのチャットを通じて思考整理や理論的な返答を訓練することを目的としたアプリです。",
      canonical: root_url,
      noindex: ! Rails.env.production?,
      og: {
        site_name: "AI_dialogue",
        title: "AI_dialogue",
        description: "AIとのチャットを通じて思考整理や理論的な返答を訓練することを目的としたアプリです。",
        type: "website",
        url: root_url,
        image: image_url("AI_dialogue.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@https://x.com/NoobOkamot",
        image: image_url("AI_dialogue.png")
      }
    }
  end
end
