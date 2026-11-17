import 'package:flutter/material.dart';

void main() => runApp(const LingoApp());

const learningLanguages = [
  'English', 'German', 'French', 'Spanish', 'Italian', 'Japanese',
  'Korean', 'Turkish', 'Arabic', 'Chinese', 'Portuguese', 'Russian',
  'Dutch', 'Hindi', 'Persian', 'Swedish', 'Greek', 'Hebrew',
];

class LingoApp extends StatefulWidget {
  const LingoApp({super.key});
  @override
  State<LingoApp> createState() => _LingoAppState();
}

class _LingoAppState extends State<LingoApp> {
  bool isPersian = true;
  String targetLanguage = 'English';
  bool started = false;
  int completedLessons = 0;
  int points = 0;

  void completeLesson(int earnedPoints) {
    setState(() {
      completedLessons++;
      points += earnedPoints;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Lingo AI',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF246BFD)),
      scaffoldBackgroundColor: const Color(0xFFF5F7FC),
      fontFamily: 'Roboto',
    ),
    home: started
      ? MainShell(
          isPersian: isPersian,
          targetLanguage: targetLanguage,
          completedLessons: completedLessons,
          points: points,
          onLanguageChanged: (v) => setState(() => targetLanguage = v),
          onUiLanguageChanged: (v) => setState(() => isPersian = v),
          onLessonCompleted: completeLesson,
        )
      : WelcomeScreen(
          isPersian: isPersian,
          onUiLanguageChanged: (v) => setState(() => isPersian = v),
          onStart: (language) => setState(() {
            targetLanguage = language;
            started = true;
          }),
        ),
  );
}

class WelcomeScreen extends StatefulWidget {
  final bool isPersian;
  final ValueChanged<bool> onUiLanguageChanged;
  final ValueChanged<String> onStart;
  const WelcomeScreen({super.key, required this.isPersian,
    required this.onUiLanguageChanged, required this.onStart});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selected = 'English';
  @override
  Widget build(BuildContext context) {
    final fa = widget.isPersian;
    return Scaffold(
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Align(alignment: AlignmentDirectional.centerEnd,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('فارسی')),
                ButtonSegment(value: false, label: Text('English')),
              ],
              selected: {widget.isPersian},
              onSelectionChanged: (v) => widget.onUiLanguageChanged(v.first),
            )),
          const SizedBox(height: 30),
          Container(height: 138,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF155EEF), Color(0xFF7B61FF)]),
              borderRadius: BorderRadius.circular(36),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(.2), blurRadius: 25, offset: const Offset(0, 10))],
            ),
            child: const Icon(Icons.public_rounded, color: Colors.white, size: 78)),
          const SizedBox(height: 20),
          const Text('Lingo AI', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF172B4D))),
          Text(fa ? 'یاد بگیر • صحبت کن • پیشرفت کن' : 'Learn • Speak • Grow',
            textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF667085))),
          const SizedBox(height: 34),
          Text(fa ? 'زبان برنامه را انتخاب کن' : 'Choose your app language',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Text(fa ? 'زبان آموزشی را انتخاب کن' : 'Choose a language to learn',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selected, isExpanded: true,
            decoration: InputDecoration(filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
            items: learningLanguages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setState(() => selected = v ?? 'English')),
          const SizedBox(height: 22),
          FilledButton(
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            onPressed: () => widget.onStart(selected),
            child: Text(fa ? 'شروع یادگیری' : 'Start learning',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          const SizedBox(height: 18),
          Text('The King Studio', textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 12)),
        ]),
      ))),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool isPersian;
  final String targetLanguage;
  final int completedLessons;
  final int points;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onUiLanguageChanged;
  final void Function(int) onLessonCompleted;
  const MainShell({super.key, required this.isPersian, required this.targetLanguage,
    required this.completedLessons, required this.points,
    required this.onLanguageChanged, required this.onUiLanguageChanged,
    required this.onLessonCompleted});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final fa = widget.isPersian;
    final pages = [
      HomePage(fa: fa, language: widget.targetLanguage,
        completed: widget.completedLessons, points: widget.points,
        onLearn: () => setState(() => tab = 1)),
      LearnPage(fa: fa, language: widget.targetLanguage,
        onLessonCompleted: widget.onLessonCompleted),
      ProgressPage(fa: fa, completed: widget.completedLessons, points: widget.points),
      ProfilePage(fa: fa, language: widget.targetLanguage,
        onLanguageChanged: widget.onLanguageChanged,
        onUiLanguageChanged: widget.onUiLanguageChanged),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home),
            label: fa ? 'خانه' : 'Home'),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), selectedIcon: const Icon(Icons.menu_book),
            label: fa ? 'یادگیری' : 'Learn'),
          NavigationDestination(icon: const Icon(Icons.insights_outlined), selectedIcon: const Icon(Icons.insights),
            label: fa ? 'پیشرفت' : 'Progress'),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person),
            label: fa ? 'پروفایل' : 'Profile'),
        ]),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool fa; final String language; final int completed; final int points; final VoidCallback onLearn;
  const HomePage({super.key, required this.fa, required this.language,
    required this.completed, required this.points, required this.onLearn});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Row(children: [
      const CircleAvatar(backgroundColor: Color(0xFFE6EEFF),
        child: Icon(Icons.waving_hand_rounded, color: Color(0xFF246BFD))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(fa ? 'خوش اومدی!' : 'Welcome back!', style: const TextStyle(color: Color(0xFF667085))),
        Text(fa ? 'آماده یادگیری هستی؟' : 'Ready to learn?',
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      ])),
      const Icon(Icons.notifications_none_rounded, size: 27),
    ]),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF175CD3), Color(0xFF6941C6)]),
        borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(fa ? 'زبان در حال یادگیری' : 'YOUR LEARNING LANGUAGE',
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(language, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(fa ? 'با یک درس کوتاه شروع کن.' : 'Start with a short lesson.',
          style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        FilledButton.tonal(onPressed: onLearn, child: Text(fa ? 'رفتن به درس‌ها' : 'Go to lessons')),
      ])),
    const SizedBox(height: 20),
    Row(children: [
      Expanded(child: StatCard(icon: Icons.check_circle_outline, value: '$completed',
        label: fa ? 'درس تکمیل‌شده' : 'Lessons done')),
      const SizedBox(width: 10),
      Expanded(child: StatCard(icon: Icons.stars_rounded, value: '$points',
        label: fa ? 'امتیاز' : 'Points')),
    ]),
    const SizedBox(height: 22),
    Text(fa ? 'تمرین‌های پیشنهادی' : 'Suggested practice',
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    const TaskTile(icon: Icons.translate_rounded, title: 'Useful vocabulary',
      subtitle: 'Learn everyday words', color: Color(0xFFE9F2FF)),
    const TaskTile(icon: Icons.headphones_rounded, title: 'Listening practice',
      subtitle: 'Train your listening skills', color: Color(0xFFFFF2E5)),
    const TaskTile(icon: Icons.quiz_rounded, title: 'Quick quiz',
      subtitle: 'Review what you learned', color: Color(0xFFE9F8EF)),
    const SizedBox(height: 12), const PremiumCard(),
  ]);
}

class StatCard extends StatelessWidget {
  final IconData icon; final String value; final String label;
  const StatCard({super.key, required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, color: Colors.white,
    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Icon(icon, color: const Color(0xFF246BFD)), const SizedBox(height: 7),
      Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
    ])));
}

class TaskTile extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color;
  const TaskTile({super.key, required this.icon, required this.title, required this.subtitle, required this.color});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: const Color(0xFF246BFD))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right)));
}

class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: const Color(0xFFFFF7E6), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFFFD98A))),
    child: Row(children: [
      const Icon(Icons.workspace_premium_rounded, color: Color(0xFFB7791F), size: 38),
      const SizedBox(width: 12),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Lingo AI Premium', style: TextStyle(fontWeight: FontWeight.w900)),
        Text('Advanced lessons and AI practice — coming soon.',
          style: TextStyle(fontSize: 12, color: Color(0xFF805B20))),
      ])),
      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    ]));
}

class Lesson {
  final String title;
  final String subtitle;
  final List<Vocab> words;
  const Lesson(this.title, this.subtitle, this.words);
}
class Vocab {
  final String foreign;
  final String meaning;
  final String example;
  const Vocab(this.foreign, this.meaning, this.example);
}

const sampleLessons = [
  Lesson('Greetings', 'Say hello and goodbye', [
    Vocab('Hello', 'سلام', 'Hello! How are you?'),
    Vocab('Good morning', 'صبح بخیر', 'Good morning, Sara.'),
    Vocab('Goodbye', 'خداحافظ', 'Goodbye! See you tomorrow.'),
  ]),
  Lesson('Introducing yourself', 'Share basic information', [
    Vocab('My name is…', 'اسم من ... است', 'My name is Alex.'),
    Vocab('Nice to meet you', 'از آشنایی خوشوقتم', 'Nice to meet you, too.'),
    Vocab('I am from…', 'من اهل ... هستم', 'I am from Berlin.'),
  ]),
  Lesson('Everyday phrases', 'Useful expressions for daily life', [
    Vocab('Please', 'لطفاً', 'Water, please.'),
    Vocab('Thank you', 'متشکرم', 'Thank you for your help.'),
    Vocab('Excuse me', 'ببخشید', 'Excuse me, where is the station?'),
  ]),
  Lesson('Numbers and time', 'Start with simple numbers', [
    Vocab('One', 'یک', 'One coffee, please.'),
    Vocab('Two', 'دو', 'I have two books.'),
    Vocab('Today', 'امروز', 'Today is a good day.'),
  ]),
];

class LearnPage extends StatelessWidget {
  final bool fa; final String language; final void Function(int) onLessonCompleted;
  const LearnPage({super.key, required this.fa, required this.language, required this.onLessonCompleted});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text(fa ? 'یادگیری' : 'Learn', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
    const SizedBox(height: 5),
    Text('${fa ? 'زبان انتخاب‌شده:' : 'Learning language:'} $language'),
    const SizedBox(height: 18),
    ...sampleLessons.asMap().entries.map((entry) => Card(
      elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFEAF0FF),
          child: Text('${entry.key + 1}', style: const TextStyle(color: Color(0xFF246BFD), fontWeight: FontWeight.bold))),
        title: Text(entry.value.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(entry.value.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(
          lesson: entry.value, fa: fa, language: language,
          onComplete: () => onLessonCompleted(10)))),
      ))),
    const SizedBox(height: 10), const PremiumCard(),
    const SizedBox(height: 10),
    Text(fa ? 'فعلاً محتوای نمونه انگلیسی است؛ محتوای بومی‌سازی‌شده زبان‌های دیگر در مرحله بعد اضافه می‌شود.'
      : 'Sample lesson content is currently in English; localized courses for more languages are planned.',
      style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
  ]);
}

class LessonScreen extends StatefulWidget {
  final Lesson lesson; final bool fa; final String language; final VoidCallback onComplete;
  const LessonScreen({super.key, required this.lesson, required this.fa,
    required this.language, required this.onComplete});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}
class _LessonScreenState extends State<LessonScreen> {
  int index = 0;
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    final word = widget.lesson.words[index];
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          LinearProgressIndicator(value: (index + 1) / widget.lesson.words.length,
            minHeight: 8, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 28),
          Text('${widget.fa ? 'درس' : 'LESSON'} ${index + 1} / ${widget.lesson.words.length}',
            style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
            child: Column(children: [
              const Icon(Icons.volume_up_rounded, size: 34, color: Color(0xFF246BFD)),
              const SizedBox(height: 20),
              Text(word.foreign, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(word.meaning, style: const TextStyle(fontSize: 21, color: Color(0xFF246BFD))),
              const Divider(height: 36),
              Text(word.example, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Color(0xFF667085))),
              const SizedBox(height: 8),
              Text(widget.fa ? 'نمونه جمله' : 'Example sentence',
                style: const TextStyle(fontSize: 12, color: Color(0xFF98A2B3))),
            ])),
          const Spacer(),
          FilledButton(
            onPressed: () {
              if (index < widget.lesson.words.length - 1) {
                setState(() => index++);
              } else if (!completed) {
                setState(() => completed = true);
                widget.onComplete();
                showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text(widget.fa ? 'آفرین! 🎉' : 'Great work! 🎉'),
                  content: Text(widget.fa ? 'درس کامل شد و ۱۰ امتیاز گرفتی.'
                    : 'Lesson completed. You earned 10 points.'),
                  actions: [TextButton(onPressed: () {
                    Navigator.pop(context); Navigator.pop(context);
                  }, child: Text(widget.fa ? 'تمام' : 'Done'))],
                ));
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(index == widget.lesson.words.length - 1
              ? (widget.fa ? 'تکمیل درس' : 'Complete lesson')
              : (widget.fa ? 'بعدی' : 'Next')),
          ),
        ])),
    );
  }
}

class ProgressPage extends StatelessWidget {
  final bool fa; final int completed; final int points;
  const ProgressPage({super.key, required this.fa, required this.completed, required this.points});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text(fa ? 'پیشرفت من' : 'My progress',
      style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
    const SizedBox(height: 18),
    Row(children: [
      Expanded(child: StatCard(icon: Icons.check_circle, value: '$completed',
        label: fa ? 'درس تکمیل‌شده' : 'Lessons completed')),
      const SizedBox(width: 10),
      Expanded(child: StatCard(icon: Icons.stars, value: '$points',
        label: fa ? 'امتیاز' : 'Points')),
    ]),
    const SizedBox(height: 20),
    Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
        const SizedBox(height: 8),
        Text(completed == 0
          ? (fa ? 'اولین درس را شروع کن!' : 'Start your first lesson!')
          : (fa ? 'آفرین، ادامه بده!' : 'Great progress — keep going!'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(fa ? 'با تکمیل هر درس امتیاز می‌گیری. آمار فعلی روی همین اجرا نگهداری می‌شود.'
          : 'Earn points by completing lessons. Progress is currently kept for this app session only.',
          textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF667085))),
      ]))),
  ]);
}

class ProfilePage extends StatelessWidget {
  final bool fa; final String language;
  final ValueChanged<String> onLanguageChanged; final ValueChanged<bool> onUiLanguageChanged;
  const ProfilePage({super.key, required this.fa, required this.language,
    required this.onLanguageChanged, required this.onUiLanguageChanged});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text(fa ? 'پروفایل و تنظیمات' : 'Profile & settings',
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
    const SizedBox(height: 20),
    Card(elevation: 0, color: Colors.white, child: Column(children: [
      ListTile(title: Text(fa ? 'زبان محیط برنامه' : 'App language'),
        subtitle: const Text('فارسی / English'),
        trailing: DropdownButton<bool>(value: fa, underline: const SizedBox(),
          items: const [DropdownMenuItem(value: true, child: Text('فارسی')),
            DropdownMenuItem(value: false, child: Text('English'))],
          onChanged: (v) { if (v != null) onUiLanguageChanged(v); })),
      const Divider(height: 1),
      ListTile(title: Text(fa ? 'زبان آموزشی' : 'Learning language'),
        subtitle: Text(language),
        trailing: DropdownButton<String>(value: language, underline: const SizedBox(),
          items: learningLanguages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: (v) { if (v != null) onLanguageChanged(v); })),
      const Divider(height: 1),
      ListTile(leading: const Icon(Icons.workspace_premium_outlined),
        title: const Text('Lingo AI Premium'),
        subtitle: Text(fa ? 'پرداخت در نسخه بعدی اضافه می‌شود.' : 'Billing integration is planned for a later version.')),
      const Divider(height: 1),
      ListTile(leading: const Icon(Icons.download_for_offline_outlined),
        title: Text(fa ? 'درس‌های آفلاین' : 'Offline lessons'),
        subtitle: Text(fa ? 'درس‌های نمونه درون برنامه هستند.' : 'Sample lessons are bundled in the app.')),
    ])),
    const SizedBox(height: 20),
    const Center(child: Text('The King Studio',
      style: TextStyle(color: Color(0xFF98A2B3), fontWeight: FontWeight.w600))),
  ]);
}
