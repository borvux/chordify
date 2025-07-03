# Chordify 🎸

A sleek, simple web application for viewing and transposing song chords. Built with Sinatra, Chordify allows you to easily change the key of a song, save the transposition, and even auto-scroll for hands-free practice. Perfect for musicians who want a straightforward, no-fuss tool to help them play in any key.

-----

## ✨ **Features**

  * **Effortless Transposition**: Instantly transpose chords up or down in semitone increments.
  * **Song Library**: Easily add your own songs by dropping `.txt` files into the `songs` directory.
  * **Auto-Scroll**: Start, stop, and control the speed of auto-scrolling for hands-free reading.
  * **Clean, Modern UI**: A dark-mode interface that's easy on the eyes and simple to navigate.
  * **Session Persistence**: Remembers your transposition settings for each song.

-----

## 🛠️ **Tech Stack**

  * **Backend**: Ruby, Sinatra
  * **Frontend**: HTML, CSS, JavaScript
  * **Server**: Puma

-----

## 🚀 **Getting Started**

### **Prerequisites**

Make sure you have `Ruby 3.2.1` installed on your system. You can check this by running:

```bash
ruby -v
```

### **Installation & Setup**

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/your-username/music-tabs-sinatra.git
    cd music-tabs-sinatra
    ```

2.  **Install dependencies**:

    ```bash
    bundle install
    ```

3.  **Add Your Songs**:
    Place your song files (in `.txt` format with chords and lyrics) into the `songs/` directory.

4.  **Run the application**:

    ```bash
    bin/server
    ```

-----
