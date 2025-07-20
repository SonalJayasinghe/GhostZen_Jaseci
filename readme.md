# GhostZen Jaseci

GhostZen is an interactive game where **the player takes the role of the Akinator**. Instead of the AI guessing your character, you ask questions to a language-model-powered bot to get hints and try to guess the hidden entity. Multiple players can play simultaneously, and a **leaderboard** keeps track of scores.

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/SonalJayasinghe/GhostZen_Jaseci.git
cd GhostZen_Jaseci
```

### 2. Install Required Python Packages

Make sure you have Python 3.10+ installed, then run:

```bash
pip install jaclang jac-cloud mtllm
```

### 3. Run the Jaseci Cloud Server

```bash
jac serve main.jac
```

> ⚠️ Ensure you are in the directory where `main.jac` is located when running the above command.

---

## 🌐 View the Frontend

To test the frontend:

1. Locate the `index.html` file in the repo.
2. Open it **directly** in **Google Chrome**.
3. **Do not** use extensions like Live Server or other local servers.

---

## 🧠 API Endpoints

### 1. Show Leaderboard

* **URL**: `http://0.0.0.0:8000/walker/ShowLeaderboard`
* **Method**: `POST`
* **Body**: None
* **Response**: List of top players

### 2. Play Game

* **URL**: `http://0.0.0.0:8000/walker/PlayGame`
* **Method**: `POST`
* **Body** (JSON):

```json
{
  "guess_or_question": "Indiana Jones",
  "userName": "Bokka"
}
```

* **Response**: LLM-generated hint or result if guess is correct

---

## 📌 Notes

* You can use any name as `userName`. The game keeps track of different users.
* The game ends when the player guesses the correct answer.
* The leaderboard is updated with your score.

---

## 📃 License

MIT (if applicable – update based on your actual license)

---

## 🙌 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

Happy guessing! 🎮
