# RepoBrowser

RepoBrowser is an iPhone app that allows you to browse GitHub repositories with ease. With a clean and intuitive interface, you can search for repositories, view details, and bookmark your favorites for quick access.

## Features

- **Explore Repositories:** 
  - Browse GitHub repositories.
  - Filter by Stars, Language, and License.
  - Paginated and infinite scroll for seamless browsing.
  - Display error messages for failed API calls.
- **Repository Details:** View repository information in detail.
- **Bookmarking:** Bookmark/Unbookmark repositories for easy access later.

## Getting Started

### Prerequisites

- Xcode 13 or later
- iOS 15.0 or later

### Installation

1. Clone the repository:
   ```zsh
   git clone https://github.com/BiaoBee/RepoBrowser.git
   ```
2. Open `RepoBrowser.xcodeproj` in Xcode.
3. Select the `RepoBrowser` scheme and build/run on a simulator or your iPhone.

## Usage

1. **Explore:** Launch the app to see trending repositories or use the search bar to find specific repositories.
2. **View Details:** Tap on any repository to see more information, including the owner’s avatar and repository stats.
3. **Bookmark:** Tap the bookmark icon to save repositories you want to revisit.
4. **Bookmarks Tab:** Access your saved repositories from the Bookmarks tab.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.


## Areas To Improve
- Features:
    - Search
    - Sync stored data
- Coding:
    - Some view are not testable
    - UT coverage
## Architecture Considerations
- Grouping vs Filtering
- Used search API 
- 