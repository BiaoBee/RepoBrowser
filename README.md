# RepoBrowser

RepoBrowser is an iPhone app that makes it easy to browse GitHub repositories. With a clean, intuitive interface, you can filter for repositories, view detailed information, and bookmark your favorites for quick access.

## Features

- **Explore Repositories:**  
  - Browse GitHub repositories.
  - Filter results by Stars, Language, and License.
  - Enjoy seamless browsing with paginated and infinite scroll.
  - Clear error messages are displayed if something goes wrong.
- **Repository Details:** Dive into detailed information for each repository.
- **Bookmarking:** Quickly bookmark or unbookmark repositories for easy access later.

## Getting Started

### Prerequisites

- Xcode 16.3 or later
- iOS 17.0 or later

### Installation

1. Clone the repository:
   ```zsh
   git clone https://github.com/BiaoBee/RepoBrowser.git
   ```
2. Open `RepoBrowser.xcodeproj` in Xcode.
3. Select the `RepoBrowser` scheme and build/run on a simulator or your iPhone.

## Usage

1. **Explore:**  
   - Launch the app to view repositories.
   - Tap the filter icon (top left) to apply filters.
   - Tap the reload button (top right) to refresh repositories with the current filters.
   - Scroll to the bottom for infinite scroll; the next page loads automatically.
   - If infinite scroll fails, tap `Load More` to manually fetch more results.
   - Any errors will be shown at the top of the screen.
2. **Repository Details:**  
   - Tap any repository to view more details.
   - Tap the bookmark icon to save repositories you want to revisit.
3. **Bookmarks Tab:**  
   - Access your saved repositories from the Bookmarks tab.
   - Remove bookmarks by tapping the `Unbookmark` button.

## Code Structure

The project is organized into several main directories:

- **RepoBrowser/**  
  The main app target, containing all core source files.
  - `ContentView.swift`, `RepoBrowserApp.swift`: App entry points and main UI setup.
  - **BookmarkStorage/**: Bookmark storage entiry.
  - **Networking/**: Networking abstractions and protocols.
  - **Services/**: Models and services for fetching and decoding repository data.
  - **Views/**: All SwiftUI views, organized by feature:
    - **BookmarksView/**: UI for displaying and managing bookmarks.
    - **ExploreView/**: UI and logic for exploring repositories, including filters and infinite scroll.
    - **RepoDetailView/**: UI for repository details.
    - **Shared/**: Reusable UI components (e.g., avatar, bookmark toggle).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## Areas for Improvement

- **Features:**
    - Add a search feature.
    - Automatically update stored bookmarks if repository data changes.
- **Code:**
    - Improve testability of some views.
    - Increase unit test coverage.
    - SwiftData is used with SwiftUI, which currently makes bookmark storage untestable.