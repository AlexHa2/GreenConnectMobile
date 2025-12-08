import 'package:GreenConnectMobile/features/package/presentation/providers/package_providers.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_card.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_empty_state.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_filter_sheet.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/widgets/package_search_bar.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/styles/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PackageListPage extends ConsumerStatefulWidget {
  const PackageListPage({super.key});

  @override
  ConsumerState<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends ConsumerState<PackageListPage> {
  final ScrollController _scrollController = ScrollController();
  
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  String? _searchQuery;
  String? _packageType;
  bool? _sortByPrice;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPackages();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMorePackages();
    }
  }

  Future<void> _loadPackages({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _currentPage = 1);
    }

    await ref.read(packageViewModelProvider.notifier).fetchPackages(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          sortByPrice: _sortByPrice,
          packageType: _packageType,
          isLoadMore: false,
        );
  }

  Future<void> _loadMorePackages() async {
    if (_isLoadingMore) return;

    final state = ref.read(packageViewModelProvider);
    final pagination = state.pagination;

    if (pagination == null || !pagination.hasNextPage) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage = pagination.nextPage!;
    });

    await ref.read(packageViewModelProvider.notifier).fetchPackages(
          pageNumber: _currentPage,
          pageSize: _pageSize,
          sortByPrice: _sortByPrice,
          packageType: _packageType,
          isLoadMore: true,
        );

    setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await _loadPackages(isRefresh: true);
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.isEmpty ? null : query;
    });
    _loadPackages(isRefresh: true);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PackageFilterSheet(
        currentPackageType: _packageType,
        currentSortByPrice: _sortByPrice,
        onFilterApplied: ({packageType, sortByPrice}) {
          setState(() {
            _packageType = packageType;
            _sortByPrice = sortByPrice;
          });
          _loadPackages(isRefresh: true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final space = spacing.screenPadding;
    final s = S.of(context)!;
    final packageState = ref.watch(packageViewModelProvider);

    final packages = _searchQuery == null
        ? packageState.packages
        : packageState.packages
            .where((package) =>
                package.name.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
                package.description
                    .toLowerCase()
                    .contains(_searchQuery!.toLowerCase()))
            .toList();

    final isInitialLoading = packageState.isLoading && packages.isEmpty;
    final hasError = packageState.errorMessage != null && packages.isEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(s.package_list),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Filter button
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterSheet,
              ),
              if (_packageType != null || _sortByPrice != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          PackageSearchBar(
            onSearch: _onSearch,
            initialValue: _searchQuery,
          ),

          // Active filters indicator
          if (_packageType != null || _sortByPrice != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: space,
                vertical: space * 0.5,
              ),
              child: Row(
                children: [
                  Text(
                    '${s.filter_packages}: ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_packageType != null) ...[
                    Chip(
                      label: Text(
                        _packageType!,
                        style: theme.textTheme.bodySmall,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _packageType = null);
                        _loadPackages(isRefresh: true);
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    SizedBox(width: space * 0.5),
                  ],
                  if (_sortByPrice != null) ...[
                    Chip(
                      label: Text(
                        _sortByPrice! ? s.price_low_to_high : s.price_high_to_low,
                        style: theme.textTheme.bodySmall,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _sortByPrice = null);
                        _loadPackages(isRefresh: true);
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
            ),

          // Content
          Expanded(
            child: isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: theme.colorScheme.error,
                            ),
                            SizedBox(height: space),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: space * 2),
                              child: Text(
                                packageState.errorMessage ?? s.error_occurred,
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: space),
                            ElevatedButton(
                              onPressed: () => _loadPackages(isRefresh: true),
                              child: Text(s.message_retry),
                            ),
                          ],
                        ),
                      )
                    : packages.isEmpty
                        ? const PackageEmptyState()
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: packages.length + (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == packages.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final package = packages[index];
                                return PackageCard(
                                  package: package,
                                  onTap: () {
                                    context.pushNamed(
                                      'package-detail',
                                      extra: {'package': package},
                                    );
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
