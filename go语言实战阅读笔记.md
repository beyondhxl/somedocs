> **《Go语言实战》阅读笔记**

<!-- more -->

## 一、关于Go语言的介绍

### 1.1、Go解决现代编程难题

Go 语言开发团队花了很长时间来解决当今软件开发人员面对的问题。开发人员在为项目选择语言时，不得不在快速开发和性能之间做出选择。C 和 C++ 这类语言提供了很快的执行速度，而 Ruby 和 Python 这类语言则擅长快速开发。Go 语言在这两者间架起了桥梁，不仅提供了高性能的语言，同时也让开发更快速。

Go 语言的编译器速度非常快，有时甚至会让人感觉不到在编译。所以，Go 开发者能显著减少等待项目构建的时间。

因为 **Go 语言内置并发机制**，所以不用被迫使用特定的线程库，就能让软件扩展，使用更多的资源。Go 语言的类型系统简单且高效，不需要为面向对象开发付出额外的心智，让开发者能专注于代码复用。**Go 语言还自带垃圾回收器，不需要用户自己管理内存**。

因为没有从编译代码到执行代码的中间过程，用动态语言编写应用程序可以快速看到输出。代价是，**动态语言不提供静态语言提供的类型安全特性**，不得不经常用大量的测试套件来避免在运行的时候出现类型错误这类 bug。

**goroutine 使用的内存比线程更少，Go 语言运行时会自动在配置的一组逻辑处理器上调度执行 goroutine**。每个逻辑处理器绑定到一个操作系统线程上。

通道是一种数据结构，可以让 goroutine 之间进行安全的数据通信。通道可以帮用户避免其他语言里常见的共享内存访问的问题。在其他语言中，如果使用全局变量或者共享内存，必须使用复杂的锁规则来防止对同一个变量的不同步修改。通道这一模式保证同一时刻只会有一个 goroutine 修改数据。

**在两个 goroutine 间传输数据是同步的，一旦传输完成，两个 goroutine 都会知道数据已经完成传输**。

需要强调的是，**通道并不提供跨 goroutine 的数据访问保护机制**。如果通过通道传输数据的一份副本，那么每个 goroutine 都持有一份副本，各自对自己的副本做修改是安全的。当传输的是指向数据的指针时，如果读和写是由不同的 goroutine 完成的，每个 goroutine 依旧需要额外的同步动作。


### 1.2、类型系统

Go 开发者使用组合（composition）设计模式，只需简单地将一个类型嵌入到另一个类型，就能复用所有的功能。

在 Go 语言中，不需要声明某个类型实现了某个接口，编译器会判断一个类型的实例是否符合正在使用的接口。

在 Go 语言中，如果一个类型实现了一个接口的所有方法，那么这个类型的实例就可以存储在这个接口类型的实例中，不需要额外声明。

## 二、Go语言读取不同数据源实例

main 函数保存在名为 main 的包里。如果 main 函数不在 main 包里，构建工具就不会生成可执行的文件。

一个包定义一组编译过的代码，包的名字类似命名空间，可以用来间接访问包内声明的标识符。这个特性可以把不同包中定义的同名标识符区别开。

关键字 import 就是导入一段代码，让用户可以访问其中的标识符，如类型、函数、常量和接口。

**所有处于同一个文件夹里的代码文件，必须使用同一个包名。按照惯例，包和文件夹同名**。

导入的路径前面有一个下划线，这个是为了让 Go 语言对包做初始化操作（即调用对应包内的所有代码文件里定义的 init() 函数），但是并不使用包里的标识符。程序中每个代码文件里定义的 init() 函数都会在 main() 函数执行之前调用。

从标准库中导入代码时，只需要提供包名。编译器总是从 GOROOT 和 GOPATH 环境变量引用的位置去查找。（目前最新的包管理是使用 **go mod**）

以小写字母开头的标识符是不公开的，不能被其他包中的代码直接访问。

```go
var matchers = make(map[string]Matcher)
```

matchers 是包级变量。

在 Go 语言中，所有变量都被初始化为其零值。对于数值类型，零值是 0；对于字符串类型，零值是空字符串；对于布尔类型，零值是 false；对于指针，零值是 nil。对于引用类型来说，所引用的底层数据结构会被初始化为对应的零值。**但是被声明为其零值的引用类型的变量，会返回 nil 作为其值。**

切片是一种实现了一个动态数组的引用类型。

简化变量声明运算符（:=）声明一个变量，同时给这个变量赋予初始值。编译器使用函数返回值的类型来确定每个变量的类型。如果提供确切的非零值初始化变量或者使用函数返回值创建变量，应该使用简化变量声明运算符。

通道（channel）、映射（map）、切片（slice）都是引用类型。

**在 main 函数返回前，清理并终止所有之前启动的 goroutine。编写启动和终止时的状态都很清晰的程序，有助减少 bug，防止资源异常**。

WaitGroup 是一个计数信号量，我们可以利用它来统计所有的 goroutine 是不是都完成了工作。

关键字 range 可以用于迭代数组、字符串、切片、映射和通道。使用 for range 迭代切片时，每次迭代会返回两个值。第一个值是迭代的元素在切片里的索引位置，第二个值是元素值的一个副本。

**下划线还有占位符的作用**。

```go
for, _ := range feeds {
}
```

查找 map 里的键时，有两个选择：要么赋值给一个变量，要么为了精确查找，赋值给两个变量。**赋值给两个变量时，第一个值和赋值给一个变量时的值一样，是 map 查找的结果值。如果指定了第二个值，就会返回一个布尔标志，来表示查找的键是否存在于 map 里。如果这个键不存在，map 会返回其值类型的零值作为返回值，如果这个键存在，map 会返回键所对应值的副本**。

一个 goroutine 是一个独立于其他函数运行的函数。使用关键字 go 启动一个 goroutine，并对这个 goroutine 做并发调度。

匿名函数是指没有明确声明名字的函数。匿名函数也可以接受声明时指定的参数。

**指针变量可以方便地在函数之间共享数据。使用指针变量可以让函数访问并修改一个变量的状态，而这个变量可以在其他函数甚至是其他 goroutine 的作用域里声明**。

在 Go 语言中，所有的变量都以值的方式传递。因为指针变量的值是所指向的内存地址，在函数间传递指针变量，是在传递这个地址值，所以依旧被看作以值的方式在传递。

Go 语言支持闭包，这里就应用了闭包。实际上，在匿名函数内访问 searchTerm 和 results 变量，也是通过闭包的形式访问的。因为有了闭包，函数可以直接访问到那些没有作为参数传入的变量。**匿名函数并没有拿到这些变量的副本，而是直接访问外层函数作用域中声明的这些变量本身**。因为 matcher 和 feed 变量每次调用时值不相同，所以并没有使用闭包的方式访问这两个变量。

因为 Go 编译器可以根据赋值运算符右边的值来推导类型，声明常量的时候不需要指定类型。

```go
const dataFile = "data/data.json"
```

我们声明了一个名叫 Feed 的结构类型。这个类型会对外暴露。这个类型里面声明了 3 个字段，每个字段的类型都是字符串，对应于数据文件中各个文档的不同字段。每个字段的声明最后` 引号里的部分被称作标记（tag）。这个标记里描述了 JSON 解码的元数据，用于创建 Feed 类型值的切片。每个标记将结构类型里字段对应到 JSON 文档里指定名字的字段。

```go
// Feed 包含我们需要处理的数据源的信息
type Feed struct {
	Name 	string `json:"site"`
	URI 	string `json:"link"`
	Type 	string `json:"type"`
}
```

```json
[
    {
        "site" : "npr",
        "link" : "http://www.npr.org/rss/rss.php?id=1001",
        "type" : "rss"
	},
    {
        "site" : "cnn",
        "link" : "http://rss.cnn.com/rss/cnn_world.rss",
        "type" : "rss"
    },
    {
        "site" : "foxnews",
        "link" : "http://feeds.foxnews.com/foxnews/world?format=xml",
        "type" : "rss"
    },
    {
        "site" : "nbcnews",
        "link" : "http://feeds.nbcnews.com/feeds/topstories",
        "type" : "rss"
    }
]
```

```go
// RetrieveFeeds 读取并反序列化源数据文件
func RetrieveFeeds() ([]*Feed, error) {
	// 打开文件
	file, err := os.Open(dataFile)
	if err != nil {
		return nil, err
	}

	// 当函数返回时
	// 关闭文件
	defer file.Close()

	// 将文件解码到一个切片里
	// 这个切片的每一项是一个指向一个Feed 类型值的指针
	var feeds []*Feed
	err = json.NewDecoder(file).Decode(&feeds)

	// 这个函数不需要检查错误，调用者会做这件事
	return feeds, err
}
```

第一个返回值是一个切片，其中每一项指向一个 Feed 类型的值（指针类型）。第二个返回值是一个 error 类型的值，用来表示函数是否调用成功。在这个代码示例里，会经常看到返回 error 类型值来表示函数是否调用成功。这种用法在标准库里也很常见。

现在让我们看看第 20 行到第 23 行。在这几行里，我们使用 os 包打开了数据文件。我们使用相对路径调用 Open 方法，并得到两个返回值。第一个返回值是一个指针，指向 File 类型的值，第二个返回值是 error 类型的值，检查 Open 调用是否成功。紧接着第 21 行就检查了返回的 error 类型错误值，如果打开文件真的有问题，就把这个错误值返回给调用者。

关键字 defer 会安排随后的函数调用在函数返回时才执行。在使用完文件后，需要主动关闭文件。使用关键字 defer 来安排调用 Close 方法，可以保证这个函数一定会被调用。哪怕函
数意外崩溃终止，也能保证关键字 defer 安排调用的函数会被执行。关键字 defer 可以缩短打开文件和关闭文件之间间隔的代码行数，有助提高代码可读性，减少错误。（申请资源、释放资源要匹配）

```go
func (dec *Decoder) Decode(v interface{}) error
```

Decode 方法接受一个类型为 interface{} 的值作为参数。这个类型在 Go 语言里很特殊，一般会配合 reflect 包里提供的反射功能一起使用。

```go
// Matcher 定义了要实现的
// 新搜索类型的行为
type Matcher interface {
	Search(feed *Feed, searchTerm string) ([]*Result, error)
}
```

interface 关键字声明了一个接口，这个接口声明了结构类型或者具名类型需要实现的行为。一个接口的行为最终由在这个接口类型中声明的方法决定。如果接口类型只包含一个方法，那么这
个类型的名字以 er 结尾。如果接口类型内部声明了多个方法，其名字需要与其行为关联。

```go
package search

// defaultMatcher 实现了默认匹配器
type defaultMatcher struct{}

// init 函数将默认匹配器注册到程序里
func init() {
	var matcher defaultMatcher
	Register("default", matcher)
}

// Search 实现了默认匹配器的行为
func (m defaultMatcher) Search(feed *Feed, searchTerm string) ([]*Result, error) {
	return nil, nil
}
```

在第 04 行，我们使用一个空结构声明了一个名叫 defaultMatcher 的结构类型。空结构在创建实例时，不会分配任何内存。这种结构很适合创建没有任何状态的类型。

```go
func (m defaultMatcher) Search
```

如果声明函数的时候带有接收者，则意味着声明了一个方法。这个方法会和指定的接收者的类型绑在一起。在我们的例子里，Search 方法与 defaultMatcher 类型的值绑在一起。这意
味着我们可以使用 defaultMatcher 类型的值或者指向这个类型值的指针来调用 Search 方法。无论我们是使用接收者类型的值来调用这个方，还是使用接收者类型值的指针来调用这个
方法，编译器都会正确地引用或者解引用对应的值，作为接收者传递给 Search 方法。

```go
// 方法声明为使用 defaultMatcher 类型的值作为接收者
func (m defaultMatcher) Search(feed *Feed, searchTerm string)

// 声明一个指向 defaultMatcher 类型值的指针
dm := new(defaultMatch)

// 编译器会解开dm 指针的引用，使用对应的值调用方法
dm.Search(feed, "test")

// 方法声明为使用指向 defaultMatcher 类型值的指针作为接收者
func (m *defaultMatcher) Search(feed *Feed, searchTerm string)

// 声明一个 defaultMatcher 类型的值
var dm defaultMatch

// 编译器会自动生成指针引用 dm 值，使用指针调用方法
dm.Search(feed, "test")
```

因为大部分方法在被调用后都需要维护接收者的值的状态，所以，一个最佳实践是，将方法的接收者声明为指针。对于 defaultMatcher 类型来说，使用值作为接收者是因为创建一个 defaultMatcher 类型的值不需要分配内存。由于 defaultMatcher 不需要维护状态，所以不需要指针形式的接收者。

与直接通过值或者指针调用方法不同，如果通过接口类型的值调用方法，规则有很大不同，使用指针作为接收者声明的方法，只能在接口类型的值是一个指针的时候被调用。使用值作为接收者声明的方法，在接口类型的值为值或者指针时，都可以被调用。

```go
// 方法声明为使用指向defaultMatcher 类型值的指针作为接收者
func (m *defaultMatcher) Search(feed *Feed, searchTerm string)

// 通过interface 类型的值来调用方法
var dm defaultMatcher
var matcher Matcher = dm // 将值赋值给接口类型
matcher.Search(feed, "test") // 使用值来调用接口方法

> go build
cannot use dm (type defaultMatcher) as type Matcher in assignment

// 方法声明为使用defaultMatcher 类型的值作为接收者
func (m defaultMatcher) Search(feed *Feed, searchTerm string)

// 通过interface 类型的值来调用方法
var dm defaultMatcher
var matcher Matcher = &dm // 将指针赋值给接口类型
matcher.Search(feed, "test") // 使用指针来调用接口方法

> go build
Build Successful
```

```go
// Match 函数，为每个数据源单独启动goroutine 来执行这个函数
// 并发地执行搜索
func Match(matcher Matcher, feed *Feed, searchTerm string, results chan<- *Result) {
	// 对特定的匹配器执行搜索
	searchResults, err := matcher.Search(feed, searchTerm)
	if err != nil {
		log.Println(err)
		return
	}

	// 将结果写入通道
	for _, result := range searchResults {
		results <- result
	}
}
```

这个函数使用实现了 Matcher 接口的值或者指针，进行真正的搜索。这个函数接受 Matcher 类型的值作为第一个参数。只有实现了 Matcher 接口的值或者指针能被接受。因为 defaultMatcher 类型使用值作为接收者，实现了这个接口，所以 defaultMatcher 类型的值或者指针可以传入这个函数。

```go
// Display 从每个单独的 goroutine 接收到结果后
// 在终端窗口输出
func Display(results chan *Result) {
	// 通道会一直被阻塞，直到有结果写入
	// 一旦通道被关闭，for 循环就会终止
	for result := range results {
		fmt.Printf("%s:\n%s\n\n", result.Field, result.Content)
	}
}
```

当通道被关闭时，通道和关键字 range 的行为，使这个函数在处理完所有结果后才会返回。


match.go 代码文件的第 40 行的 for range 循环会一直阻塞，直到有结果写入通道。在某个搜索 goroutine 向通道写入结果后（如在 match.go 代码文件的第 31 行所见），for  range 循环被唤醒，读出这些结果。之后，结果会立刻写到日志中。看上去这个 for range 循环会无限循环下去，但其实不然。一旦 search.go 代码文件第 51 行关闭了通道，for range 循环就会终止，Display 函数也会返回。


```go
type (
// item 根据 item 字段的标签，将定义的字段
// 与 rss 文档的字段关联起来
item struct {
	XMLName xml.Name `xml:"item"`
	PubDate string `xml:"pubDate"`
	Title string `xml:"title"`
	Description string `xml:"description"`
	Link string `xml:"link"`
	GUID string `xml:"guid"`
	GeoRssPoint string `xml:"georss:point"`
}

// image 根据 image 字段的标签，将定义的字段
// 与 rss 文档的字段关联起来
image struct {
	XMLName xml.Name `xml:"image"`
	URL string `xml:"url"`
	Title string `xml:"title"`
	Link string `xml:"link"`
}

// channel 根据 channel 字段的标签，将定义的字段
// 与 rss 文档的字段关联起来
channel struct {
	XMLName xml.Name `xml:"channel"`
	Title string `xml:"title"`
	Description string `xml:"description"`
	Link string `xml:"link"`
	PubDate string `xml:"pubDate"`
	LastBuildDate string `xml:"lastBuildDate"`
	TTL string `xml:"ttl"`
	Language string `xml:"language"`
	ManagingEditor string `xml:"managingEditor"`
	WebMaster string `xml:"webMaster"`
	Image image `xml:"image"`
	Item []item `xml:"item"`
}

// rssDocument 定义了与 rss 文档关联的字段
rssDocument struct {
	XMLName xml.Name `xml:"rss"`
	Channel channel `xml:"channel"`
}

)
```

```go
// Search 在文档中查找特定的搜索项
func (m rssMatcher) Search(feed *search.Feed, searchTerm string) ([]*search.Result, error) {
	var results []*search.Result

	log.Printf("Search Feed Type[%s] Site[%s] For Uri[%s]\n", feed.Type, feed.Name, feed.URI)

	// 获取要搜索的数据
	document, err := m.retrieve(feed)

	if err != nil {
		return nil, err
	}

	for _, channelItem := range document.Channel.Item{
		// 检查标题部分是否包含搜索项
		matched, err := regexp.MatchString(searchTerm, channelItem.Title)
		if err != nil{
			return nil, err
		}

		// 如果找到匹配的项，将其作为结果保存
		if matched {
			results = append(results, &search.Result{
				Field: "Title",
				Content: channelItem.Title,
			})
		}

		// 检查描述部分是否包含搜索项
		matched, err = regexp.MatchString(searchTerm, channelItem.Description)
		if err != nil {
			return nil, err
		}

		// 如果找到匹配的项，将其作为结果保存
		if matched {
			results = append(results, &search.Result{
				Field: "Description",
				Content: channelItem.Description,
				})
		}
		return results, nil
	}
}
```

```go
for _, channelItem := range document.Channel.Item {
	// 检查标题部分是否包含搜索项
	matched, err := regexp.MatchString(searchTerm, channelItem.Title)
	if err != nil {
		return nil, err
	}
}
```

既然 document.Channel.Item 是一个 item 类型值的切片，我们在第 81 行对其使用 for range 循环，依次访问其内部的每一项。在第 83 行，我们使用 regexp 包里的 MatchString 函数，对 channelItem 值里的 Title 字段进行搜索，查找是否有匹配的搜索项。之后在第 84 行检查错误。

```go
// 如果找到匹配的项，将其作为结果保存
if matched {
	results = append(results, &search.Result{
		Field: "Title",
		Content: channelItem.Title,
	})
}
```

如果调用 MatchString 方法返回的 matched 的值为真，我们使用内置的 append 函数，将搜索结果加入到 results 切片里。append 这个内置函数会根据切片需要，决定是否
要增加切片的长度和容量。我们会在第 4 章了解关于内置函数 append 的更多知识。这个函数的第一个参数是希望追加到的切片，第二个参数是要追加的值。在这个例子里，追加到切
片的值是一个指向 Result 类型值的指针。这个值直接使用字面声明的方式，初始化为 Result 类型的值。之后使用取地址运算符（&），获得这个新值的地址。最终将这个指针存
入了切片。

## 三、打包和工具链

### 3.1、包

在 Go 语言里，包是个非常重要的概念。其设计理念是使用包来封装不同语义单元的功能。这样做，能够更好地复用代码，并对每个包内的数据的使用有更好的控制。

所有的 .go 文件，除了空行和注释，都应该在第一行声明自己所属的包。每个包都在一个单独的目录里。不能把多个包放到同一个目录中，也不能把同一个包的文件分拆到多个不同目录中。这意味着，同一个目录下的所有 .go 文件必须声明同一个包名。

给包及其目录命名时，应该使用简洁、清晰且全小写的名字，这有利于开发时频繁输入包名。

一般情况下，包被导入后会使用你的包名作为默认的名字，不过这个导入后的名字可以修改。这个特性在需要导入不同目录的同名包时很有用。

**main包**

在 Go 语言里，命名为 main 的包具有特殊的含义。Go 语言的编译程序会试图把这种名字的包编译为二进制可执行文件。

当编译器发现某个包的名字为 main 时，它一定也会发现名为 main() 的函数，否则不会创建可执行文件。main() 函数是程序的入口，所以，如果没有这个函数，程序就没有办法开始执行。程序编译时，会使用声明 main 包的代码所在的目录的目录名作为二进制可执行文件的文件名。

在 Go 语言里，命令是指任何可执行程序，包更常用来指语义上可导入的功能单元。