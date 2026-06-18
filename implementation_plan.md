# Cấu trúc Layered Architecture (Clean Architecture) với GetX

Đề xuất cấu trúc thư mục phân lớp (data, domain, presentation) kết hợp với GetX để quản lý trạng thái và định tuyến (routing) trong dự án.

## Đề xuất cấu trúc thư mục

Thư mục `lib/` sẽ được tổ chức lại như sau:
```text
lib/
├── core/                   # Các tài nguyên dùng chung của ứng dụng
│   ├── theme/              # Định nghĩa giao diện (Theme, Colors, Typography)
│   ├── routes/             # Định nghĩa danh sách các màn hình và định tuyến (GetX Routing)
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── values/             # Hằng số (Constants, Strings, Assets)
│
├── domain/                 # Lớp Nghiệp vụ (Business Logic) - Không phụ thuộc thư viện ngoài
│   ├── entities/           # Các thực thể dữ liệu nghiệp vụ chính
│   ├── repositories/       # Các interface định nghĩa giao tiếp dữ liệu (Abstract Classes)
│   └── usecases/           # Các kịch bản nghiệp vụ cụ thể (Use Cases)
│
├── data/                   # Lớp Dữ liệu (Data Access)
│   ├── models/             # Các Data Models (chuyển đổi từ/thành JSON)
│   ├── providers/          # Các nguồn cấp dữ liệu trực tiếp (API clients, Database helper)
│   └── repositories/       # Hiện thực hóa (Implementation) các Repository từ domain layer
│
├── presentation/           # Lớp Hiển thị (UI/UX)
│   ├── bindings/           # GetX Bindings để khởi tạo dependencies (Controller, Repository...)
│   ├── controllers/        # GetX Controllers điều phối dữ liệu cho UI
│   └── pages/              # Giao diện chính (UI Screens/Views)
│       └── counter/        # Ví dụ một màn hình Counter phân lớp
│
└── main.dart               # Điểm khởi đầu ứng dụng (GetMaterialApp)
```

## Các thay đổi đề xuất

### 1. Cấu hình pubspec.yaml
- Thêm thư viện `get: ^4.6.6` vào danh sách `dependencies` để hỗ trợ State Management, Dependency Injection và Route Management.

### 2. Triển khai code mẫu cho tính năng Counter
Để minh họa kiến trúc này hoạt động như thế nào, chúng ta sẽ thiết lập một tính năng Counter nhỏ theo đúng cấu trúc:
- **Domain**:
  - [NEW] `lib/domain/entities/counter.dart`: Định nghĩa Entity của Counter.
  - [NEW] `lib/domain/repositories/counter_repository.dart`: Định nghĩa Interface Repository.
- **Data**:
  - [NEW] `lib/data/models/counter_model.dart`: Định nghĩa Model (hỗ trợ chuyển đổi từ JSON/Map).
  - [NEW] `lib/data/repositories/counter_repository_impl.dart`: Triển khai Interface của Repository (giả lập lưu trữ hoặc lấy dữ liệu).
- **Presentation**:
  - [NEW] `lib/presentation/controllers/counter_controller.dart`: GetxController xử lý logic tăng/giảm và tương tác với Repository.
  - [NEW] `lib/presentation/bindings/counter_binding.dart`: Bindings đăng ký Controller và Repository.
  - [NEW] `lib/presentation/pages/counter_page.dart`: UI của trang Counter sử dụng `Obx` và `GetView`.
- **Core**:
  - [NEW] `lib/core/routes/app_routes.dart`: Định nghĩa các tên route.
  - [NEW] `lib/core/routes/app_pages.dart`: Cấu hình danh sách các GetPage tương ứng với Bindings và Views.
- **Main**:
  - [MODIFY] `lib/main.dart`: Sử dụng `GetMaterialApp` và khởi tạo ứng dụng trỏ tới route mặc định của CounterPage.

### 3. Cập nhật Widget Test
- [MODIFY] `test/widget_test.dart`: Điều chỉnh kiểm thử để phù hợp với giao diện và định tuyến mới của GetX.

---

## Kế hoạch kiểm thử (Verification Plan)

### Automated Tests
- Chạy lệnh `flutter test` để xác minh widget test hoạt động bình thường với cấu trúc GetX mới.

### Manual Verification
- Chạy ứng dụng trên môi trường giả lập (hoặc trình duyệt/thiết bị thực nếu cần) để kiểm tra các chức năng:
  - Hiển thị giao diện của CounterPage.
  - Nhấp vào nút cộng để tăng giá trị counter.
  - Kiểm tra xem trạng thái thay đổi tức thì thông qua GetX phản ứng (Reactive).
