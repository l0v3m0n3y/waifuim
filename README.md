# waifuim
web-api for waifu.im . The API for your Waifu content. Access thousands of categorized anime illustrations via our robust REST API or browse freely.
# main
```swift
import Foundation
let client = Waifuim()

do {
    let images = try await client.getImagesList()
    print(images)
} catch {
    print("Error: \(error)")
}

```

# Launch (your script)
```
swift run
```
