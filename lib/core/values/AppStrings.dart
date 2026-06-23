// ignore_for_file: file_names

class AppStrings {
  // Common Status
  static const String statusAll = 'All';
  static const String statusCompleted = 'Completed';
  static const String statusUncompleted = 'Uncompleted';
  static const String statusAllVi = 'Tất cả';
  static const String statusCompletedVi = 'Đã xong';
  static const String statusUncompletedVi = 'Chưa xong';
  
  static const String success = 'Thành công';
  static const String cancel = 'Hủy';
  static const String delete = 'Xóa';

  // Task List Page
  static const String taskManagement = 'Quản lý công việc';
  static const String viewCounterScreen = 'Xem màn hình Counter';
  static const String noTasks = 'Chưa có công việc nào!';
  static const String noTasksMatchFilter = 'Không có công việc nào khớp bộ lọc!';
  static const String confirmDelete = 'Xác nhận xóa';

  static String taskCount(int count) => '$count công việc hiện có';
  static String confirmDeleteTask(String title) => 'Bạn có chắc chắn muốn xóa công việc "$title" không?';
  static String taskDeleted(String title) => 'Đã xóa công việc "$title"';

  // Task Form Page
  static const String editTask = 'Chỉnh sửa công việc';
  static const String newTask = 'Tạo công việc mới';
  static const String taskTitle = 'Tiêu đề công việc';
  static const String taskTitleHint = 'Nhập tiêu đề...';
  static const String taskTitleEmpty = 'Tiêu đề không được để trống';
  static const String taskDescription = 'Mô tả chi tiết';
  static const String taskDescriptionHint = 'Nhập mô tả chi tiết của công việc...';
  static const String taskDescriptionEmpty = 'Mô tả không được để trống';
  static const String saveChanges = 'LƯU THAY ĐỔI';
  static const String createTask = 'TẠO CÔNG VIỆC';

  static String taskUpdatedMock(String title) => 'Đã cập nhật công việc "$title" (Mock)';
  static String taskCreatedMock(String title) => 'Đã tạo công việc mới "$title" (Mock)';
}
