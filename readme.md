# GhostZen Jacinator

GhostZen Jacinator is an interactive game where **the player takes the role of the Akinator**. Instead of the AI guessing your character, you ask questions to a language-model-powered bot to get hints and try to guess the hidden entity. Multiple players can play simultaneously, and a **leaderboard** keeps track of scores.

---

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/SonalJayasinghe/GhostZen_Jaseci.git
cd GhostZen_Jaseci
```

### 2. Create and Activate a Virtual Environment

```bash
# Create virtual environment
python -m venv jac-env

# Activate on Unix/macOS
source jac-env/bin/activate

# Activate on Windows
jac-env\Scripts\activate
```

### 3. Install Required Python Packages

```bash
pip install jaclang jac-cloud mtllm
```

### 4. Export OpenAI API Key

Replace `your-api-key-here` with your actual API key.

#### On macOS/Linux:
```bash
export OPENAI_API_KEY="your-api-key-here"
```

#### On Windows (Command Prompt):
```cmd
set OPENAI_API_KEY="your-api-key-here"
```

#### On Windows (PowerShell):
```powershell
$env:OPENAI_API_KEY="your-api-key-here"
```

### 5. Run the Jaseci Cloud Server

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

* **URL**: `http://localhost:8000/walker/ShowLeaderboard`
* **Method**: `POST`
* **Body**: None
* **Response**: List of top players

### 2. Play Game

* **URL**: `http://localhost:8000/walker/PlayGame`
* **Method**: `POST`
* **Body** (JSON):

```json
{
  "guess_or_question": "Is he a fictional character ?",
  "userName": "Jaseci"
}
```

* **Response**: LLM-generated hint or result if guess is correct

---

## 📌 Notes

* You can use any name as `userName`. The game keeps track of different users.
* The game ends when the player guesses the correct answer.
* The leaderboard is updated with your score.

---

Happy guessing! 🎮
