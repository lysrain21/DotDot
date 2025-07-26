import 'dart:io';

void main() {
  var file = File('/Users/yushenli/Documents/my_code/Commit/task_agent_flutter/lib/views/pages/daily_summary_page.dart');
  var lines = file.readAsLinesSync();
  for (var i = 158; i <= 165; i++) {
    print('Line $i: [${lines[i-1]}]');
  }
}