module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {},
    fontFamily: {
      teko: ['Teko', 'sans-serif']
    }
  },
  plugins: [require("daisyui")],
}
